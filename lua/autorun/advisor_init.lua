-- Entry point for Advisor
if SERVER then
    include("advisor/init.lua")
else
    include("advisor/cl_init.lua")
end