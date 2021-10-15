AddCSLuaFile()
include("moduleloader.lua")

Advisor.CurrentVersion = "0.0.0"
Advisor.RepositoryURL = "https://github.com/Erlite/Advisor"
Advisor.VersionFile = Advisor.RepositoryURL .. "/blob/master/version.txt"

Advisor.Modules.LoadAllModules()