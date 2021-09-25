-- This is distributed under the MIT license since I made it public in Advisor's repository
-- Feel free to use it in your addons or gamemodes. You'll need a couple of modifications for gamemodes but I'm sure you'll figure them out, it's mostly filesystem paths.
-- Don't forget to replace the global table (Advisor) with your own.

AddCSLuaFile()
include("advisor/module.lua")
include("advisor/loaderconfig.lua")

--[[
    Module loader to load modules located in the modules directory.
    All module files must start with the following options:
        - cl
            - client side only files
        - sh
        - pl (player_xxxx)
            - shared files
        - sv
            - server only files.

    Yeah this is probably the most overkill thing I've written, but does it work? Hell yeah.
--]] 

Advisor = Advisor or {}
Advisor.ModuleUtils = Advisor.ModuleUtils or {}
Advisor.Modules = Advisor.Modules or {}
Advisor.Modules.LoadedFiles = {}
Advisor.Modules.LoadedDirectories = {}
Advisor.Modules.FolderName = "advisor-modules"

local loadedModules = {}

-- Surrogates for file.Exists() and file.IsDir() for directories
function Advisor.ModuleUtils.DirExists(name, path)
    if SERVER then return file.IsDir(name, path) end
    if file.IsDir(name, path) then return true end

    local _, dirs = file.Find(name .. "*", path)
    if dirs == nil or #dirs == 0 then return false end

    local splits = string.Split(name, "/")
    local dirName = splits[#splits]
    
    return table.HasValue(dirs, dirName)
end

function Advisor.ModuleUtils.PathExists(name, path)
    return file.Exists(name, path) or (CLIENT and Advisor.ModuleUtils.DirExists(name, path))
end

local function ServerInclude(path, fileName, recSpace)
    if SERVER then
        print(recSpace .. " - [SV] Loaded " .. fileName)
        include(path .. fileName)
    end
end
 
local function SharedInclude(path, fileName, recSpace)
    print(recSpace .. " - [SH] Loaded " .. fileName)
    AddCSLuaFile(path .. fileName)
    include(path .. fileName)
end

local function ClientInclude(path, fileName, recSpace)
    if CLIENT then
        print(recSpace .. " - [CL] Loaded " .. fileName)
        include(path .. fileName)
    else
        print(recSpace .. " - [CL] Sending " .. fileName)
        AddCSLuaFile(path .. fileName)
    end
end 

local function RealmInclude(path, fileName, recSpace)
    if #fileName < 2 || !string.EndsWith(fileName, ".lua") then
        Error("Attempted to include invalid file \'" .. fileName .. "\'.")
    end

    -- Don't include files if they've already been included.
    if Advisor.Modules.LoadedFiles[path .. fileName] then return end

    local realm = string.sub(fileName, 0, 2)
    realm = string.lower(realm)

    local action =
    {
        ["sv"] = function() ServerInclude(path, fileName, recSpace) end,
        ["sh"] = function() SharedInclude(path, fileName, recSpace) end,
        ["cl"] = function() ClientInclude(path, fileName, recSpace) end,
        ["pl"] = function() SharedInclude(path, fileName, recSpace) end, -- player_xxx files are shared.
    }

    if action[realm] then 
        action[realm]()
        Advisor.Modules.LoadedFiles[path .. fileName] = true
    else
        MsgC(Color(255, 90, 90), "Invalid realm \'" .. realm .. "\' in file \'" .. fileName.. "\'.\n")
    end
end

local lastLoadedModule = ""

local function LoadModule(moduleName, numRecursions)
    numRecursions = numRecursions or 0

    -- If not recursive, then check that the module name is unique.
    if numRecursions == 0 then
        if loadedModules[moduleName] then
            print("[" .. moduleName .. "]")
            print(" - A module with that name was already loaded. Skipping...")
            return
        else
            loadedModules[moduleName] = true
        end
    end

    -- Get the module's directory from its name.
    local searchPath = string.format("%s/%s/", Advisor.Modules.FolderName, moduleName)
    local modulePath = Advisor.Modules.FolderName .. "/" .. moduleName .. "/"

    -- Return if already loaded.
    if Advisor.Modules.LoadedDirectories[modulePath] then
        return
    else
        Advisor.Modules.LoadedDirectories[modulePath] = true
    end

    local moduleFiles, moduleDirectory = file.Find(searchPath .. "*", "LUA")
    if moduleDirectory == nil then
        Error("Cannot find module \'" .. moduleName .. "\'! Your modules are broken, re-install them.\n")
        return 
    end 
 
    local recSpace = string.rep(" ", numRecursions * 2)

    if lastLoadedModule != moduleName and numRecursions == 0 then
        print()
    end
    lastLoadedModule = moduleName

    -- If the module is empty, quit.
    if #moduleFiles == 0 && table.GetFirstValue(moduleDirectory) == nil then
        return
    end 

    -- Get the module's lua configuration.
    local moduleConfig = nil
    local moduleConfigPath = modulePath .. "module_" .. moduleName .. ".lua"

    if (numRecursions == 0 && file.Exists(searchPath .. "module_" .. moduleName .. ".lua", "LUA")) then
        print(recSpace .. "[" .. moduleName .. "]")
        moduleConfig = include(moduleConfigPath)
        if !moduleConfig then
            ErrorNoHalt(string.format(" - Invalid module file, skipping module.\n", moduleName))
            return
        else
            
            if SERVER and not moduleConfig:IsServerOnly() then 
                -- Send the module config file to clients.
                AddCSLuaFile(moduleConfigPath) 
            end

            if moduleName:lower() != moduleConfig:GetName():lower() then
                print(" - " .. moduleConfig:GetName())
            end
            print(" - " .. moduleConfig:GetDescription())

            if #moduleConfig:GetLoadOrder() != 0 then
                print(" - Load Order: ")

                for _, v in pairs(moduleConfig:GetLoadOrder()) do
                    print("  > " .. v)
                end
            end
            print()
        end
    end

    -- If there's no module config, or if it's invalid, return. Only for root module directories, not subdirectories.
    if numRecursions == 0 && !moduleConfig then
        Error(" - Module has no module configuration file or is invalid, ignoring module. \n")
        return
    end

    -- Load files in the load order they're setup in.
    if numRecursions == 0 then
        for _, path in pairs(moduleConfig:GetLoadOrder()) do
            local loadPath = searchPath .. path
            local fileModulePath = modulePath .. path

            fileModulePath = string.Replace(loadPath, "\\", "/") -- Replace back slashes with forward slashes.
            fileModulePath = string.Replace(fileModulePath, "//", "/") -- Remove excess slashes
            fileModulePath = string.Trim(fileModulePath, "/")  -- Remove leading and trailing slashes

            loadPath = string.Replace(loadPath, "\\", "/") -- Replace back slashes with forward slashes.
            loadPath = string.Replace(loadPath, "//", "/") -- Remove excess slashes
            loadPath = string.Replace(loadPath, "*", "") -- No wildcards
            loadPath = string.Trim(loadPath, "/") -- Remove leading and trailing slashes

            -- Pattern for invalid paths.
            local invalid, _ = string.find(loadPath, "..", 1, true) -- Cannot go backwards in directories.
            if invalid then
                ErrorNoHalt(string.format(" - Found invalid path '%s' in module file. Ignoring.\n", path))
                continue
            end

            -- Check if the path exists.
            if !Advisor.ModuleUtils.PathExists(loadPath, "LUA") then
                if SERVER then
                    ErrorNoHalt(string.format(" - Cannot find path '%s'. Ignoring.\n", loadPath))
                end
                continue
            end

            -- If it's a directory, get all root files and directories and load them.
            if Advisor.ModuleUtils.DirExists(loadPath, "LUA") then
                local files, dirs = file.Find(loadPath .. "/*", "LUA")

                -- If already loaded, hecc off.
                if Advisor.Modules.LoadedDirectories[fileModulePath] then continue end

                -- TODO: Check that we still have things to load here (i.e. haven't been loaded via loadOrder yet)
                local loadRecSpace = string.rep(" ", (numRecursions + 1) * 2)
                print(loadRecSpace .. "[" .. moduleName .. "/" .. path .. "]")

                -- Load all root files first.
                for _, f in pairs(files) do
                    local fi = string.lower(f)
                    if string.EndsWith(fi, ".lua") then
                        RealmInclude(fileModulePath .. "/", fi, loadRecSpace)
                    end
                end

                -- Load subdirectories.
                for _, dir in pairs(dirs) do
                    LoadModule(moduleName .. "/" .. dir, numRecursions + 1)
                end
            else -- then we just load the file. 
                -- If already loaded, hecc off.
                if Advisor.Modules.LoadedFiles[fileModulePath] then continue end

                -- Do some magic if the path also contains folders.
                local tbl = string.Split(fileModulePath, "/")
                local fi = tbl[#tbl]

                if #tbl != 1 then
                    fileModulePath = string.sub(fileModulePath, 1, #fileModulePath - #fi)
                end

                if string.EndsWith(fi, ".lua") then
                    RealmInclude(fileModulePath, fi, recSpace) 
                end
            end
        end
    end

    -- Load other files in current directory.
    for _, f in pairs(moduleFiles) do
        local fi = string.lower(f) 
        local moduleFile = "module_" .. moduleName .. ".lua"
        if string.EndsWith(fi, ".lua") && fi != moduleFile  then 
            RealmInclude(modulePath, fi, recSpace)
        end 
    end 

    -- Load any subdirectories.
    for _, dir in pairs(moduleDirectory) do
        LoadModule(moduleName .. "/" .. dir, numRecursions + 1)
    end
end

-- You must call this function in a shared realm to load all modules. Do it as soon as possible.
function Advisor.Modules.LoadAllModules()

    -- Splash screen baby
    for _, line in pairs(loaderConfig.splash) do
        print(line)
    end

    print()
    print("=== Loading Modules ===")
    print()
    
    -- Load modules in the order they are inside the loader config
    for _, mod in pairs(loaderConfig.loadOrder) do
        if loadedModules[mod] then continue end

        LoadModule(mod)
    end

    local _, modules = file.Find(Advisor.Modules.FolderName .. "/*", "LUA")
    for _, dir in pairs(modules) do
        if loadedModules[dir] then continue end
        if loaderConfig.ignoredModules[dir] then continue end
        LoadModule(dir)
    end

    print()
    print() 
    print("=== Finished loading all modules ===")
    print()
    print()

    -- TODO: remove
    if SERVER then 
        Advisor.SQL.Initialize()
    end
end 