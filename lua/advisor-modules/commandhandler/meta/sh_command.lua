Advisor = Advisor or {}
Advisor.Command = Advisor.Command or {}
Advisor.Command.__index = Advisor.Command

function Advisor.Command.new()
    local tbl = 
    {
        category = "",
        name = "",
        description = "",
        arguments = {},
        numRequired = 0,
        numOptional = 0,
        Callback = nil,
    }

    setmetatable(tbl, Advisor.Command)
    return tbl
end

AccessorFunc(Advisor.Command, "category", "Category", FORCE_STRING)
AccessorFunc(Advisor.Command, "name", "Name", FORCE_STRING)
AccessorFunc(Advisor.Command, "description", "Description", FORCE_STRING)
GetterFunc(Advisor.Command, "arguments", "Arguments")
GetterFunc(Advisor.Command, "numRequired", "RequiredAmount")
GetterFunc(Advisor.Command, "numOptional", "OptionalAmount")


--[[
    Adds an argument to this command.
    @param name The name of the argument.
    @param argtype The type of this argument (see parsers)
    @param description Optional description for this argument.
    @returns The command, as to chain functions.
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

    -- Check that there is no optional argument before this one, as this is illegal.
    if #self.arguments > 0 and self.arguments[#self.arguments]:GetOptional() then
        ErrorNoHaltWithStack(string.format("Cannot add a required argument after an optional one."))
        return
    end

    -- Check that there is no remainder argument before this one, as this is illegal.
    if #self.arguments > 0 and self.arguments[#self.arguments]:GetRemainder() then
        ErrorNoHaltWithStack(string.format("Cannot add an argument after a remainder one."))
        return
    end

    local arg = Advisor.CommandArg()
    arg:SetName(name)
    arg:SetType(argType)
    arg:SetDescription(description or "")

    self.arguments[#self.arguments + 1] = arg
    self.numRequired = self.numRequired + 1
    return self
end

--[[
    Adds an optional argument to this command.
    @param name The name of the argument.
    @param argtype The type of this argument (see parsers)
    @param default The default value for this argument if it isn't given by the user.
    @param description Optional description for this argument.
    @returns The command, as to chain functions.
--]]
function Advisor.Command:AddOptionalArgument(name, argType, default, description)
    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Could not add argument with invalid name '%s'", name or "nil"))
        return
    end

    if not Advisor.CommandHandler.HasParser(argType) then
        ErrorNoHaltWithStack(string.format("Could not add argument with invalid type '%s'", argType or "nil"))
        return
    end

    -- Check that there is no remainder argument before this one, as this is illegal.
    if #self.arguments > 0 and self.arguments[#self.arguments]:GetOptional() then
        ErrorNoHaltWithStack(string.format("Cannot add an optional argument after a remainder one."))
        return
    end

    local arg = Advisor.CommandArg()
    arg:SetName(name)
    arg:SetDescription(description or "")
    arg:SetType(argType)
    arg:SetOptional(true)
    arg:SetDefault(default)

    self.arguments[#self.arguments + 1] = arg
    self.numOptional = self.numOptional + 1
    return self  
end

--[[
    Adds an argument that handles all the remaining text in a command.
    Argument will be passed as a string.
    @param name The name of the argument.
    @param description Optional description for this argument.
--]]
function Advisor.Command:AddRemainderArgument(name, description)
    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Could not add argument with invalid name '%s'", name or "nil"))
        return
    end

    -- Check that there is no optional argument before this one, as this is illegal.
    if #self.arguments > 0 and self.arguments[#self.arguments]:GetOptional() then
        ErrorNoHaltWithStack(string.format("Cannot add a remainder argument after an optional one."))
        return
    end

    local arg = Advisor.CommandArg()
    arg:SetName(name)
    arg:SetDescription(description or "")
    arg:SetRemainder(true)

    self.arguments[#self.arguments + 1] = arg
end

setmetatable(Advisor.Command, {__call = Advisor.Command.new})