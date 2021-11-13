Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}
Advisor.Permissions.Usergroups = Advisor.Permissions.Usergroups or {}
Advisor.Permissions.UsergroupMap = Advisor.Permissions.UsergroupMap or {}


-- Do NOT modify this. This should only hold the default Source engine usergroups.
Advisor.Permissions.DefaultUsergroups = 
{
    ["superadmin"] = true,
    ["admin"] = true,
    ["user"] = true,
}

function Advisor.Permissions.GetUsergroup(name)
    return Advisor.Permissions.UsergroupMap[name]
end

-- Called when an admin mod registers a usergroup using CAMI
-- No need to network anything here, other admin mods are expected to register in CAMI on both sides.
-- If they don't, screw them.
local function OnUsergroupRegistered(group, source)
    if source == Advisor.Source then return end

    -- If one already exists we'll just update the source.
    local knownGroup = Advisor.Permissions.UsergroupMap[group.Name]
    if knownGroup then
        if knownGroup:GetSource() == Advisor.Source then
            knownGroup:SetPartialControl(true)
            knownGroup:SetSource(tostring(source or "Unknown"))
        end

        hook.Run("Advisor.OnUsergroupUpdated", knownGroup)
    else 
        local newGroup = Advisor.Usergroup.FromCAMIGroup(group)
        Advisor.Permissions.UsergroupMap[group.Name] = newGroup
        Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = newGroup
        hook.Run("Advisor.OnUsergroupAdded", newGroup)
    end
end

hook.Add("CAMI.OnUsergroupRegistered", "Advisor.HandleCAMIRegisteredGroup", OnUsergroupRegistered)

local function OnUsergroupUnregistered(group, source)
    if source == Advisor.Source then return end

    local knownGroup = Advisor.Permissions.UsergroupMap[group.Name]
    if not knownGroup then return end

    local rebuilt = {}
    for i = 1, #Advisor.Permissions.Usergroups do
        local uGroup = Advisor.Permissions.Usergroups[i]
        if uGroup ~= knownGroup then 
            rebuilt[#rebuilt + 1] = uGroup
        end
    end

    Advisor.Permissions.UsergroupMap[group.Name] = nil 
    Advisor.Permissions.Usergroups = rebuilt

    hook.Run("Advisor.OnUsergroupRemoved", knownGroup)
end

hook.Add("CAMI.OnUsergroupUnregistered", "Advisor.HandleCAMIUnreagisteredGroup", OnUsergroupUnregistered)