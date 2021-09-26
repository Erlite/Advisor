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

    if not Advisor.Config.Commands.CaseSensitive then
        name = name:lower()
    end
    
    Advisor.CommandHandler.Commands[name] = cmd

    -- Add the command to the category ordered list.
    if not Advisor.CommandHandler.OrderedCommands[category] then 
        Advisor.CommandHandler.OrderedCommands[category] = {}
    end

    local tbl = Advisor.CommandHandler.OrderedCommands[category]
    tbl[#tbl + 1] = cmd
    
    return cmd
end

function Advisor.CommandHandler.GetCommand(txt)
    return Advisor.CommandHandler.Commands[txt]
end