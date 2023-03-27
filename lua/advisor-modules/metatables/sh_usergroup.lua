Advisor = Advisor or {}
Advisor.Usergroup = {}
Advisor.Usergroup.__index = Advisor.Usergroup

-- Data is expected to be a row from advisor_usergroups
function Advisor.Usergroup.new(self, data)
    local tbl = nil
    if istable(data) then
        tbl = 
        {
            name = data["name"],
            display_name = data["display_name"],
            color = tonumber(data["color"]) or 0xFFFFFF,
            can_delete = data["can_delete"] ~= "0",
            inherits = data["inherits"],
            source = Advisor.Source,
            partial_control = false,
            permissions = {}
        }
    else
        tbl =
        {
            name = "",
            display_name = "",
            color = 0xFFFFFF,
            can_delete = true,
            inherits = "",
            source = "",
            partial_control = false,
            permissions = {}
        }
    end

    setmetatable(tbl, Advisor.Usergroup)
    return tbl
end

AccessorFunc(Advisor.Usergroup, "name", "Name", FORCE_STRING)
AccessorFunc(Advisor.Usergroup, "permissions", "Permissions")
AccessorFunc(Advisor.Usergroup, "can_delete", "CanDelete", FORCE_BOOL)
AccessorFunc(Advisor.Usergroup, "inherits", "Inherits", FORCE_STRING)
AccessorFunc(Advisor.Usergroup, "source", "Source", FORCE_STRING)
AccessorFunc(Advisor.Usergroup, "partial_control", "PartialControl", FORCE_BOOL)

function Advisor.Usergroup:GetReplicatedProperties(rt)
    rt:AddString("name")
    rt:AddString("display_name")
        :SetReplicationCondition(function(tbl) return tbl.display_name and #tbl.display_name > 0 end)
        :SetDefaultValue("")
    rt:AddUInt("color", 24)
        :SetReplicationCondition(function(tbl) return tbl:GetColor() ~= Color(255, 255, 255) end)
        :SetDefaultValue(0xFFFFFF)
    rt:AddBool("can_delete")
    rt:AddString("inherits")
        :SetReplicationCondition(function(tbl) return tbl.inherits ~= "user" end)
        :SetDefaultValue("user")
    rt:AddString("source")
        :SetReplicationCondition(function(tbl) return tbl.source ~= Advisor.Source end)
        :SetDefaultValue(Advisor.Source)
    rt:AddBool("partial_control")
    rt:AddValueTable("permissions", 16)
        :SetReplicationCondition(function(tbl) return #tbl.permissions ~= 0 end)
        :SetDefaultValue({})
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
    c = bit.bor(c, bit.lshift(color.r, 16))
    c = bit.bor(c, bit.lshift(color.g, 8))
    c = bit.bor(c, color.b)

    self.color = c
end

function Advisor.Usergroup:HasPermission(perm)
    return self.permissions[perm]
end

function Advisor.Usergroup:SetPermission(name, value)
    self.permissions[name] = value and true or false
end

function Advisor.Usergroup:GetCAMIUsergroup()
    return { Name = self.name, Inherits = self.inherits, CAMI_Source = self.source } 
end

function Advisor.Usergroup:IsControlledByAdvisor()
    return self.partial_control or self.source == Advisor.Source
end

function Advisor.Usergroup.FromCAMIGroup(group)
    local newGroup = Advisor.Usergroup()
    newGroup:SetName(group.Name)
    newGroup:SetInherits(group.Inherits)
    newGroup:SetSource(group.CAMI_Source or "Unknown")
    return newGroup
end

local defaults = 
{
    ["user"] = true,
    ["admin"] = true,
    ["superadmin"] = true
}

function Advisor.Usergroup:IsDefaultUsergroup()
    return defaults[self.name]
end

-- Returns the usergroups this group can inherit from.
function Advisor.Usergroup:GetInheritableUsergroups()
    local allowed = { "user" }
    if self:GetName() == "user" then
        return allowed
    end

    for _, group in ipairs(Advisor.Permissions.GetUsergroups()) do
        if group:GetName() ~= self:GetName() and group:GetName() ~= "user" then
            local currentBase = group:GetInherits()
            local isAllowed = true
            while currentBase ~= "user" and currentBase ~= nil do
                if currentBase == self:GetName() then
                    isAllowed = false 
                    break
                end

                local baseGroup = Advisor.Permissions.GetUsergroup(currentBase)
                if not baseGroup then break end
                currentBase = baseGroup:GetInherits()
            end

            if isAllowed then
                allowed[#allowed + 1] = group:GetName()
            end
        end
    end

    return allowed
end

setmetatable(Advisor.Usergroup, {__call = Advisor.Usergroup.new})
Replicate.SetupMetaTable(Advisor.Usergroup, "Advisor.Usergroup")