Advisor = Advisor or {}
Advisor.UsergroupDelta = Advisor.UsergroupDelta or {}
Advisor.UsergroupDelta.__index = Advisor.UsergroupDelta

function Advisor.UsergroupDelta.new()
    local tbl = 
    {
        target = "",
        new_name = nil,
        new_display_name = nil,
        new_inheritance = nil,
        new_color = nil,
        granted_permissions = {},
        revoked_permissions = {},
    }

    setmetatable(tbl, Advisor.UsergroupDelta)
    return tbl
end

AccessorFunc(Advisor.UsergroupDelta, "target", "Target", FORCE_STRING)
AccessorFunc(Advisor.UsergroupDelta, "new_name", "Name", FORCE_STRING)
AccessorFunc(Advisor.UsergroupDelta, "new_display_name", "DisplayName", FORCE_STRING)
AccessorFunc(Advisor.UsergroupDelta, "new_inheritance", "Inherits", FORCE_STRING)
AccessorFunc(Advisor.UsergroupDelta, "new_color", "Color")
AccessorFunc(Advisor.UsergroupDelta, "granted_permissions", "GrantedPermissions")
AccessorFunc(Advisor.UsergroupDelta, "revoked_permissions", "RevokedPermissions")

function Advisor.UsergroupDelta:GetReplicatedProperties(rt)
    rt:AddString("target")
    rt:AddString("new_name")
        :SetReplicationCondition(function (tbl) return tbl.new_name ~= nil end)
    rt:AddString("new_display_name")
        :SetReplicationCondition(function (tbl) return tbl.new_display_name ~= nil end)
    rt:AddString("new_inheritance")
        :SetReplicationCondition(function (tbl) return tbl.new_inheritance ~= nil end)
    rt:AddColor("new_color")
        :SetReplicationCondition(function (tbl) return tbl.new_color ~= nil end)
    rt:AddOrderedList("granted_permissions", ReplicationType.String)
    rt:AddOrderedList("revoked_permissions", ReplicationType.String)
end

setmetatable(Advisor.UsergroupDelta, {__call = Advisor.UsergroupDelta.new})
Replicate.SetupMetaTable(Advisor.UsergroupDelta, "Advisor.UsergroupDelta")