Advisor = Advisor or {}
Advisor.Command = {}
Advisor.Command.__index = Advisor.Command

function Advisor.Command.new()
    local tbl = 
    {
        category = "",
        name = "",
        description = "",
        arguments = {},
        Callback = nil,
    }

    setmetatable(tbl, Advisor.Command)
    return tbl
end

AccessorFunc(Advisor.Command, "category", "Category", FORCE_STRING)
AccessorFunc(Advisor.Command, "name", "Name", FORCE_STRING)
AccessorFunc(Advisor.Command, "description", "Description", FORCE_STRING)

function Advisor.Command:GetArguments() 
    return self.arguments
end

--[[
    Adds an argument to this command.
    @param name The name of the argument.
    @param argtype The type of this argument (see ARGTYPE enum)
    @param description Optional description for this argument.
--]]
function Advisor.Command:AddArgument(name, argType, description)
    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Could not add argument with invalid name '%s'", name or "nil"))
        return
    end

    if not Advisor.CommandHandler.HasParser(argType) then
        ErrorNoHaltWithStack(string.format("Could not add argument with invalid type '%s'", argType or "nil"))
        return
    end

    local arg = Advisor.CommandArg()
    arg:SetName(name)
    arg:SetType(argType)
    arg:SetDescription(description or "")

    self.arguments[#self.arguments + 1] = arg
end


setmetatable(Advisor.Command, {__call = Advisor.Command.new})