Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}
Advisor.CommandHandler.Commands = Advisor.CommandHandler.Commands or {}
Advisor.CommandHandler.OrderedCommands = Advisor.CommandHandler.OrderedCommands or {}
Advisor.CommandHandler.Parsers = Advisor.CommandHandler.Parsers or {}

function Advisor.CommandHandler.RegisterParser(name, tbl)
    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Cannot register parser with invalid name '%s'", name or "nil"))
        return
    end

    if not isfunction(tbl.Parse) then
        ErrorNoHaltWithStack(string.format("Parser '%s' is missing function Parse()", name))
        return
    end

    if Advisor.CommandHandler.Parsers[name] then
        Advisor.Log.Warning(LogCommands, "Registering parser '%s' will overwrite existing one.", name)
    end

    table.Inherit(tbl, Advisor.ArgumentParser)
    Advisor.CommandHandler.Parsers[name] = tbl
    Advisor.Log.Debug(LogCommands, "Registered parser '%s'.", name)
end

function Advisor.CommandHandler.HasParser(name)
    return Advisor.CommandHandler.Parsers[name]
end

function Advisor.CommandHandler.GetParser(name)
    return Advisor.CommandHandler.Parsers[name]
end

function Advisor.CommandHandler.RegisterCommand(category, name, description)
    if not isstring(category) or #category == 0 then
        ErrorNoHaltWithStack(string.format("Could not register command with invalid category '%s'", category or "nil"))
        return nil
    end

    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Could not register command with invalid name '%s'", name or "nil"))
        return nil
    end

    local cmd = Advisor.Command()
    cmd:SetName(name)
    cmd:SetCategory(category)
    cmd:SetDescription(description or "")

    if Advisor.CommandHandler.Commands[name] then
        Advisor.Log.Debug(LogCommands, "Overwriting command '%s' due to already existing one.", name)
    end

    Advisor.Log.Debug(LogCommands, "Registered command '%s' in category '%s'.", name, category)    
    Advisor.CommandHandler.Commands[name:lower()] = cmd

    -- Add the command to the category ordered list.
    if not Advisor.CommandHandler.OrderedCommands[category] then 
        Advisor.CommandHandler.OrderedCommands[category] = {}
    end

    local tbl = Advisor.CommandHandler.OrderedCommands[category]
    tbl[#tbl + 1] = cmd

    -- Add a concommand for the new command.
    local concommandName = "advisor_" .. name:lower()
    -- @todo autocomplete handler.
    concommand.Add(concommandName, Advisor.CommandHandler.HandleConCommand, Advisor.CommandHandler.HandleAutocompletion, cmd:GetDescription())

    return cmd
end

function Advisor.CommandHandler.GetCommand(txt)
    return Advisor.CommandHandler.Commands[txt:lower()]
end

function Advisor.CommandHandler.HandleConCommand(sender, cmd, args, argsString)
    if not cmd:StartWith("advisor_") then return end

    local name = cmd:sub(#("advisor_") + 1, #cmd)
    local advisorCmd = Advisor.CommandHandler.GetCommand(name)

    if not advisorCmd then 
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "unknown_command")
        return
    end

    local cmdArgs = Advisor.Utils.ToStringArray(argsString)
    local raw = cmd .. " " .. argsString

    if CLIENT then
        Advisor.CommandHandler.Server_RunCommand(raw, advisorCmd, cmdArgs) 
    else
        Advisor.CommandHandler.RunCommand(sender, raw, advisorCmd, cmdArgs)
    end
end

function Advisor.CommandHandler.HandleAutocompletion(cmd, args)
    if SERVER then return {} end

    if not cmd:StartWith("advisor_") then return end

    local name = cmd:sub(#("advisor_") + 1, #cmd)
    local advCmd = Advisor.CommandHandler.GetCommand(name)

    if not advCmd then return {} end

    local cmdArgs = advCmd:GetArguments()
    local splitArgs = Advisor.Utils.ToStringArray(args)

    local displayArgs = string.Split(args, " ")
    local toDisplay = " "
    for i = 1, #displayArgs - 1 do
        toDisplay = toDisplay .. displayArgs[i] .. " "
    end

    if #splitArgs >= #cmdArgs then
        local lastArg = cmdArgs[#cmdArgs]
        if lastArg and lastArg:GetRemainder() then 
            local auto = { cmd .. toDisplay .. "[" .. lastArg:GetName() .. "]" }
            if #lastArg:GetDescription() ~= 0 then 
                auto = { cmd .. toDisplay .. "[" .. lastArg:GetName() .. "]: " .. lastArg:GetDescription() }
            end

            return auto
        end
    end

    local currArg = cmdArgs[#splitArgs]
    local rawCurrArg = splitArgs[#splitArgs]

    -- If the raw args have a space which is culled by the string array function, move to the next argument
    -- only if we actually have an argument before
    if args:EndsWith(" ") and #args:Trim() ~= 0 and (splitArgs[#splitArgs] and not splitArgs[#splitArgs]:EndsWith(" ")) then 
        currArg = cmdArgs[#splitArgs + 1]
        rawCurrArg = ""
    end

    if not currArg then return {} end

    local parser = Advisor.CommandHandler.GetParser(currArg:GetType())
    if not parser then return {} end

    local result = parser:Autocomplete(currArg, rawCurrArg)
    if not result or not istable(result) then return {} end

    local sanitized = {}
    for i = 1, #result do
        sanitized[i] = cmd .. toDisplay .. result[i] 
    end

    return sanitized
end

function Advisor.CommandHandler.RunCommand(sender, raw, cmd, args)
    if not cmd or getmetatable(cmd) ~= Advisor.Command then 
        PrintTable(cmd)
        ErrorNoHaltWithStack(string.format("Expected Advisor.Command, got: '%s'", cmd and type(cmd) or "nil"))
        return 
    end

    if not isfunction(cmd.Callback) then
        return
    end

    local parsedArgs = {}
    local cmdArgs = cmd:GetArguments()
    local ctx = Advisor.CommandContext()
    ctx:SetCommand(cmd)
    ctx:SetSender(sender)
    ctx:SetRawMessage(raw)
    ctx:SetParsedArguments(parsedArgs)

    -- Check that we have enough arguments to satisfy the command's request.
    if #args < cmd:GetRequiredAmount() then
        local missingArg = cmdArgs[#args]
        Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "missing_argument", missingArg:GetName())
        return ""
    end

    for i = 1, #cmdArgs do
        local arg = cmdArgs[i]
        local msgArg = args[i]

        -- break if the argument is a remainder one
        if arg:GetRemainder() then break end

        local parser = Advisor.CommandHandler.GetParser(arg:GetType())
        if not parser then 
            Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "parsers", "unknown", arg:GetType())
            return ""
        end

        if msgArg then
            local success, result = parser:Parse(ctx, msgArg)
            if not success then 
                Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), result.namespace, result.key, unpack(result.args or {}))
                return ""
            end 

            parsedArgs[#parsedArgs + 1] = result
        elseif arg:GetOptional() then
            parsedArgs[#parsedArgs + 1] = arg:GetDefault()
        else
            Advisor.Utils.LocalizedMessage(sender, Color(255, 185, 0), "commands", "missing_argument", arg:GetName())
            return ""
        end
    end

    -- If the last argument is a remainder one, we'll pass the remaining text as a string.
    local lastArg = cmdArgs[#cmdArgs]
    if lastArg and lastArg:GetRemainder() then
        local rawName = string.Split(raw, " ")[1]

        local remainder = ""
        for i = #cmdArgs, #args do
            remainder = remainder .. args[i] .. " "
        end

        parsedArgs[#parsedArgs + 1] = remainder:sub(1, #remainder - 1)
    end

    -- And now we execute the command.
    local success, errorMsg = pcall(cmd.Callback, ctx, unpack(parsedArgs))
    if success then return "" end

    Advisor.Log.Error(LogCommands, "An error has occured while executing command '%s': %s", cmd:GetName(), errorMsg)
    Advisor.Utils.LocalizedMessage(sender, Color(255, 90, 90), "commands", "error_thrown", { cmd:GetName(), errorMsg } )
end