Advisor = Advisor or {}
Advisor.CommandContext = {}
Advisor.CommandContext.__index = Advisor.CommandContext

function Advisor.CommandContext.new()
    local tbl = 
    {
        command = nil,
        sender = nil,
        rawMessage = "",
        parsedArguments = {},
        time = os.time(),
    }

    setmetatable(tbl, Advisor.CommandContext)
    return tbl
end

AccessorFunc(Advisor.CommandContext, "command", "Command")
AccessorFunc(Advisor.CommandContext, "sender", "Sender")
AccessorFunc(Advisor.CommandContext, "rawMessage", "RawMessage")
AccessorFunc(Advisor.CommandContext, "parsedArguments", "ParsedArguments")
GetterFunc(Advisor.CommandContext, "time", "Time")

setmetatable(Advisor.CommandContext, {__call = Advisor.CommandContext.new})