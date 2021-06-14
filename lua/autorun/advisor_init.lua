-- Entry point for Advisor
if SERVER then
    AddCSLuaFile("advisor/cl_init.lua")
    include("advisor/init.lua")
else
    include("advisor/cl_init.lua")
end