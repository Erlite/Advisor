--[[
    DO NOT TOUCH 
--]]

Advisor = Advisor or {}
Advisor.Config = Advisor.Config or {}

--[[
    You can start touching things below.
--]]


--[[ Determines what database type to use for Advisor's data.
-- sqlite: the default local storage database used by Garry's Mod
-- mysqloo: used for connecting to remote databases (requires installing mysqloo: https://github.com/FredyH/MySQLOO)
-- tmysql: used for connecting to remote databases (requires installing tmysql: https://github.com/SuperiorServers/gm_tmysql4)
--]]

Advisor.Config.DatabaseType = "sqlite"

-- Only used with mysqloo or tmysql, ignore if using sqlite.
-- The remote database configuration.
Advisor.Config.DatabaseConfig = 
{
    -- IP of the remote database to connect to
    host = "127.0.0.1",
    -- Name of the table Advisor will use
    name = "advisor",
    -- Username of the database account
    user = "root",
    -- Password of the database account
    pass = "",
    -- Port to use when connecting to the database (defaults to 3306)
    port = 3306
}