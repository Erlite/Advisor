AddCSLuaFile()
include("moduleloader.lua")

Advisor.CurrentVersion = "0.1.0"
Advisor.RepositoryURL = "https://github.com/Erlite/Advisor"
Advisor.VersionFile = "https://raw.githubusercontent.com/Erlite/Advisor/master/version.txt"

Advisor.Modules.LoadAllModules()