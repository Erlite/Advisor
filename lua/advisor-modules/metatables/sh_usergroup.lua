Advisor = Advisor or {}
Advisor.Usergroup = {}
Advisor.Usergroup.__index = Advisor.Usergroup

function Advisor.Usergroup.new()
    local tbl =
    {
        name = "",
        display_name = "",
        color = 0xFFFFFF,
        can_delete = false,
        inherits = "",
        permissions = {}
    }

    setmetatable(tbl, Advisor.Usergroup)
    return tbl
end

AccessorFunc(Advisor.Usergroup, "name", "Name", FORCE_STRING)
AccessorFunc(Advisor.Usergroup, "permissions", "Permissions")
AccessorFunc(Advisor.Usergroup, "can_delete", "CanDelete", FORCE_BOOL)
AccessorFunc(Advisor.Usergroup, "inherits", "Inherits", FORCE_STRING)

function Advisor.Usergroup:GetReplicatedProperties(rt)
    rt:AddString("name")
    rt:AddString("displayName")
        :SetReplicationCondition(function(tbl) return tbl.displayName and #tbl.displayName > 0 end)
        :SetDefaultValue("")
    rt:AddUInt("color", 24)
        :SetReplicationCondition(function(tbl) return tbl.color ~= Color(255, 255, 255) end)
        :SetDefaultValue(Color(255, 255, 255))
    rt:AddBool("can_delete")
    rt:AddString("inherits")
        :SetReplicationCondition(function (tbl) return tbl.inherits ~= "user" end)
        :SetDefaultValue("user")
    rt:AddValueTable("permissions", 16)
end

function Advisor.Usergroup:GetDisplayName()
    return (self.display_name and #self.display_name > 0) and self.display_name or self.name
end

function Advisor.Usergroup:SetDisplayName(name)
    self.display_name = tostring(name)
end

-- Convert the 4-byte integer representation of the color to a Color table
function Advisor.Usergroup:GetColor()
    local R = bit.band(bit.rshift(self.color, 16), 0xFF)
    local G = bit.band(bit.rshift(self.color, 8), 0xFF)
    local B = bit.band(self.color, 0xFF)

    return Color(R, G, B)
end

function Advisor.Usergroup:SetColor(color)
    if not color or not IsColor(color) then
        error("Cannot set role color to invalid color: " .. color or "nil")
    end

    local c = 0
    c = bit.bor(c, bit.lshift(color.R, 16))
    c = bit.bor(c, bit.lshift(color.G, 8))
    c = bit.bor(c, color.B)

    self.color = c
end

function Advisor.Usergroup:HasPermission(perm)
    return self.permissions[perm]
end

setmetatable(Advisor.Usergroup, {__call = Advisor.Usergroup.new})
Replicate.SetupMetaTable(Advisor.Usergroup, "Advisor.Usergroup")