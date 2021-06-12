Advisor = Advisor or {}
Advisor.SQL = Advisor.SQL or {}

local migrationsFolder = Advisor.Modules.FolderName .. "/sql/migrations/"
local migrations = {}

local function SetMigrationVersion(version)
    if not version or not isnumber(version) then
        error("Cannot set migration to invalid version '" .. version or "nil" .. "'")
    end

    local query = 
    [[
        UPDATE 'advisor_migrations'
        SET version = {{version}}
    ]]

    local params =
    {
        ["version"] = version
    }

    Advisor.SQL.Database:query(query, params, function(success, message)
        if not success then 
            Advisor.Log.Error(LogSQL, "Failed to set migration version to %i with %s", version, message)
        end
    end)
end

local function RunMigration(version)
    if not migrations[version] then 
        error("Could not run migration " .. version .. " as it does not exist!")
    end

    local db = Advisor.SQL.Database
    local data = file.Read(migrationsFolder .. migrations[version], "LUA")

    if not data then 
        error("Could not read migration at " .. migrationsFolder .. migrations[version])
    end

    Advisor.Log.Info(LogSQL, "Running migration '%s'", migrations[version])

    db:query(data, {}, function(success, message, result, affectedRows)
        if success then
            Advisor.Log.Info(LogSQL, "Success! Affected rows: %i", #affectedRows)
            SetMigrationVersion(version)

            if migrations[version + 1] then
                RunMigration(version + 1)
            else
                Advisor.Log.Info(LogSQL, "All migrations completed.")
                Advisor.SQL.OnMigrationSucceeded()
            end
            return
        end
        
        Advisor.Log.Error(LogSQL, "Migration failed with %s", message)
        Advisor.Log.Error(LogSQL, "This is a fatal error and will likely cause issues with Advisor. Contact support.")
        return
    end)
end

function Advisor.SQL.Migrate(funcSuccess)
    if not Advisor.SQL.IsInitialized then
        Advisor.Log.Error(LogSQL, "Cannot migrate database: SQL module is not initialized.")
        return 
    end

    Advisor.Log.Info(LogSQL, "Initializing database migrations...")
    local db = Advisor.SQL.Database

    local migrateQuery = 
    [[
        CREATE TABLE IF NOT EXISTS 'advisor_migrations' (version INTEGER NOT NULL); 
        INSERT INTO 'advisor_migrations'
        SELECT 0
        WHERE NOT EXISTS (SELECT * FROM 'advisor_migrations');

        SELECT * FROM 'advisor_migrations' LIMIT 1;
    ]]

    -- Create the migration version table if it doesn't exist and grab the current version.
    db:query(migrateQuery, {}, Advisor.SQL.OnVersionRetrieved)
end

function Advisor.SQL.OnVersionRetrieved(success, message, result, affectedRows)
    if not success then
        Advisor.Log.Error(LogSQL, "Failed to start migrating the database, %s", message)
        return
    end

    local currentVersion = tonumber(result[1].version)
    if not currentVersion then 
        Advisor.Log.Error(LogSQL, "Database version is invalid, this is fatal!")
        return
    end

    Advisor.Log.Info(LogSQL, "Current database version: %i", currentVersion)

    -- Load all SQL files in the migrations folder

    local sqlFiles, _ = file.Find(migrationsFolder .. "*.sql", "LUA", "nameasc")
    Advisor.Log.Info(LogSQL, "Found %i migrations.", #sqlFiles)

    for _, fi in ipairs(sqlFiles) do
        local fileName = string.GetFileFromFilename(fi)
        local spl = string.Split(fileName, "_")
        if #spl < 2 then
            Advisor.Log.Warning(LogSQL, "Invalid migration '%s': naming convention is 'version_migration-name.sql'. Skipping.", fileName)
            continue
        end

        local version = tonumber(spl[1])
        if not version or version < 1 then
            Advisor.Log.Warning(LogSQL, "Invalid migration '%s': version must be a valid number, minimum 1. Skipping.", fileName)
            continue
        end

        if migrations[version] then
            Advisor.Log.Warning(LogSQL, "Migration '%s' conflicts with '%s'. Two migrations cannot have the same version.", fileName, migrations[version])
            continue
        end

        if version ~= #migrations + 1 then
            Advisor.Log.Error(LogSQL, "Migration '%s' does not follow versioning order. Versions must be ordinal and increment one by one.", fileName)
            Advisor.Log.Error(LogSQL, "Aborting migrations.")
            return
        end

        migrations[version] = fileName
    end

    if #migrations == 0 or #migrations <= currentVersion then
        Advisor.Log.Info(LogSQL, "No migrations to run, already up to date.")
        return
    end

    Advisor.Log.Warning(LogSQL, "Database is %i version(s) behind! Running migrations.", #migrations - currentVersion)
    RunMigration(currentVersion + 1)
end