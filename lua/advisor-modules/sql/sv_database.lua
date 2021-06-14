Advisor = Advisor or {}
Advisor.SQL = Advisor.SQL or {}
Advisor.SQL.Database = Advisor.SQL.Database or nil
Advisor.SQL.IsInitialized = Advisor.SQL.IsInitialized or false

function Advisor.SQL.Initialize()

    if Advisor.SQL.Database then
        Advisor.Log.Error(LogSQL, "Attempted to initialize SQL database, but it already is ready.")
        return
    end

    if not Gsql then 
        Advisor.Log.Error(LogSQL, "==========================================================================")
        Advisor.Log.Error(LogSQL, "= Could not find Gsql, this is a fatal error as databases will not work! =")
        Advisor.Log.Error(LogSQL, "==========================================================================")
        return
    end

    if not Gsql.moduleExists(Advisor.Config.DatabaseType) then
        Advisor.Log.Error(LogSQL, " Invalid database type '%s', defaulting to 'sqlite' ", Advisor.Config.DatabaseType)
        Advisor.Config.DatabaseType = "sqlite"
    end

    Gsql:new(Advisor.Config.DatabaseType, Advisor.Config.DatabaseConfig, function(success, message, db)
        if success then
            Advisor.Log.Info(LogSQL, "Successfully connected to the database.")
            Advisor.SQL.Database = db
            Advisor.SQL.OnInitialized()
        else
            Advisor.Log.Error(LogSQL, "Failed to connect to the database with error '%s'", message)
        end
    end)
end

function Advisor.SQL.OnInitialized()

    if Advisor.SQL.IsInitialized or not Advisor.SQL.Database then 
        Advisor.Log.Error(LogSQL, "Cannot initialize SQL: already initialized.")
        return
    end

    Advisor.SQL.IsInitialized = true

    -- Handle migrating the database if it is out of date (or doesn't exist)
    Advisor.SQL.Migrate()
end

function Advisor.SQL.OnMigrationSucceeded()
    hook.Run("Advisor.DatabaseReady")
end