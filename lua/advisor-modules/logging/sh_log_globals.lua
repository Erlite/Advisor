-- Advisor default log verbosities and categories. Do NOT edit these. 
-- Feel free to add your own in another file, or below these ones. They MUST be globals to work efficiently.
LogNone = Advisor.Log.RegisterLogLevel( LogVerbosity(-1, "None", Color(255, 255, 255)) )
LogVeryVerbose = Advisor.Log.RegisterLogLevel( LogVerbosity(0, "VeryVerbose", Color(0, 170, 255)) )
LogVerbose = Advisor.Log.RegisterLogLevel( LogVerbosity(1, "Verbose", Color(0, 213, 255)) )
LogDebug = Advisor.Log.RegisterLogLevel( LogVerbosity(2, "Debug", Color(0, 255, 255)) )
LogInfo = Advisor.Log.RegisterLogLevel( LogVerbosity(100, "Info", Color(255, 255, 255)) )
LogWarning = Advisor.Log.RegisterLogLevel( LogVerbosity(999, "Warning", Color(255, 187, 0)) )
LogError = Advisor.Log.RegisterLogLevel( LogVerbosity(999, "Error", Color(255, 90, 90)) )

-- Categories. Same as above, feel free to add your own either under this or as globals elsewhere.
-- Order is category name, and default verbosity
LogConfig = Advisor.Log.RegisterLogCategory( LogCategory("Config", LogInfo) )
LogCommands = Advisor.Log.RegisterLogCategory( LogCategory("Commands", LogInfo) )
LogAdvisor = Advisor.Log.RegisterLogCategory( LogCategory("Advisor", LogInfo) )
LogLocalization = Advisor.Log.RegisterLogCategory( LogCategory("Localization", LogInfo) )
LogNet = Advisor.Log.RegisterLogCategory( LogCategory("Net", LogInfo) )
LogUtils = Advisor.Log.RegisterLogCategory( LogCategory("Utils", LogInfo) )
LogUI = Advisor.Log.RegisterLogCategory( LogCategory("UI", LogInfo) )
LogSQL = Advisor.Log.RegisterLogCategory( LogCategory("SQL", LogInfo) )

Advisor.Log.CurrentVerbosity = LogInfo 