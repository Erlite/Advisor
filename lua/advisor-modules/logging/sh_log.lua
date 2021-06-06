Advisor = Advisor or {}
Advisor.Log = Advisor.Log or {}

local verbosities = verbosities or {}
local categories = categories or {}

function Advisor.Log.RegisterLogLevel(verb)
    if verb == nil then return nil end
    verbosities[verb:GetName()] = verb
    return verb
end

function Advisor.Log.RegisterLogCategory(cat)
    if cat == nil then return nil end
    categories[cat:GetName()] = cat
    return cat
end

function Advisor.Log.GetVerbosity(name)
    if name == nil then return nil end
    return verbosities[name]
end

function Advisor.Log.GetCategory(name)
    if name == nil then return nil end
    return categories[name]
end

function Advisor.Log.LogMsg(cat, verbosity, message, ...)
    local args = ...
    if !istable(args) then args = {...} end 
    if #args != 0 then
        message = string.format(message, unpack(args))
    end
    local msg = LogMessage(cat, verbosity, message)
    if msg then hook.Run("Advisor.OnLogMessage", msg) end
end

function Advisor.Log.VeryVerbose(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogVeryVerbose:GetID() && cat:GetDefaultVerbosity():GetID() > LogVeryVerbose:GetID() then return end
    Advisor.Log.LogMsg(cat, LogVeryVerbose, message, args)
end

function Advisor.Log.Verbose(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogVerbose:GetID() && cat:GetDefaultVerbosity():GetID() > LogVerbose:GetID() then return end
    Advisor.Log.LogMsg(cat, LogVerbose, message, args)
end

function Advisor.Log.Debug(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogDebug:GetID() && cat:GetDefaultVerbosity():GetID() > LogDebug:GetID() then return end
    Advisor.Log.LogMsg(cat, LogDebug, message, args)
end

function Advisor.Log.Info(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogInfo:GetID() && cat:GetDefaultVerbosity():GetID() > LogInfo:GetID() then return end
    Advisor.Log.LogMsg(cat, LogInfo, message, args)
end

function Advisor.Log.Warning(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogWarning:GetID() && cat:GetDefaultVerbosity():GetID() > LogWarning:GetID() then return end
    Advisor.Log.LogMsg(cat, LogWarning, message, args)
end

function Advisor.Log.Error(cat, message, ...)
    local args = {...}
    if Advisor.Log.GetCurrentVerbosity():GetID() > LogError:GetID() && cat:GetDefaultVerbosity():GetID() > LogError:GetID() then return end
    Advisor.Log.LogMsg(cat, LogError, message, args)
end

function Advisor.Log.GetCurrentVerbosity()
    local var = GetConVar("Advisor_loglevel")
    if var == nil or !isstring(var:GetString()) or #var:GetString() == 0 then return verbosities["Info"] end

    local str = var:GetString()
    str = string.sub(str, 1, 1) .. string.sub(str, 2)
    return verbosities[str] or verbosities["Info"]
end

local verbCache = nil
local verbLongest = nil

local function GetVerbositySpaces(name)
    -- Quick caching check to avoid doing all of this for no reason (i.e. still the same as last check)
    if verbCache == nil || verbCache != #verbosities then
        verbCache = #verbosities
        verbLongest = 0
        for _, v in pairs(verbosities) do
            if #v:GetName() > verbLongest then
                verbLongest = #v:GetName()
            end
        end

    end
    -- If the specified name is as long as the longuest verbosity, just return empty strings.
    if verbLongest == #name then
        return "", ""
    end

    -- Else, we need to find the amount to place.
    local diff = verbLongest - #name
    -- If odd, then add a space to the left immediately.
    local verbLeft = ""
    local verbRight = ""
    if math.fmod(diff, 2) != 0 then
        verbLeft = " "
        diff = diff - 1
    end

    -- Add the spaces required.
    while diff > 0 do
        if #verbLeft > #verbRight then
            verbRight = verbRight .. " "
        else
            verbLeft = verbLeft .. " "
        end

        diff = diff - 1
    end

    return verbLeft, verbRight
end

-- Log messages to console. Some fancy tricks used for people with OCD. 
local function OnMessageLogged(msg)
    local verbLeft, verbRight = GetVerbositySpaces(msg:GetVerbosity():GetName())
    local color = msg:GetVerbosity():GetColor()
    MsgC(color, string.format("[%s%s%s] %s: %s", verbLeft, msg:GetVerbosity():GetName(), verbRight, msg:GetCategory():GetName(), msg:GetMessage()), "\n")
end

local function DumpLogLevels()
    print("====================")
    print("= Valid log levels =")
    print("====================")

    for k, _ in pairs(verbosities) do
        print(k)
    end

    print()
end

concommand.Add("advisor_log_dumplevels", DumpLogLevels)

hook.Add("Advisor.OnLogMessage", "LogMessageToConsole", OnMessageLogged)