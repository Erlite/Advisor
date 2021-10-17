Advisor = Advisor or {}
Advisor.UsergroupPermission = {}
Advisor.UsergroupPermission.__index = Advisor.UsergroupPermission

function Advisor.UsergroupPermission.new()
    local tbl = 
    {
        usergroup_name = "", 
        permission = "",
    }

    setmetatable(tbl, Advisor.UsergroupPermission)
    return tbl
end

AccessorFunc(Advisor.UsergroupPermission, "usergroup_name", "UsergroupName", FORCE_STRING)
AccessorFunc(Advisor.UsergroupPermission, "permission", "Permission", FORCE_STRING)

setmetatable(Advisor.UsergroupPermission, {__call = Advisor.UsergroupPermission.new})