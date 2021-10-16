local tbl = 
{
    name = "Logging",
    description = "Logging library used to log messages to the console and other outputs.",
    loadOrder = 
    {
        "meta/",
        "sh_log.lua",
        "sh_log_globals.lua"
    }
}

return Module(tbl)