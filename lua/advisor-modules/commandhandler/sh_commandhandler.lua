Advisor = Advisor or {}
Advisor.CommandHandler = Advisor.CommandHandler or {}
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