Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}
Advisor.Permissions.Usergroups = Advisor.Permissions.Usergroups or {}
Advisor.Permissions.UsergroupMap = Advisor.Permissions.UsergroupMap or {}

util.AddNetworkString("Advisor.ClientSendUsergroups")

local function SynchronizeClientUsergroups(ply)
    if istable(ply) and #ply == 0 then return end

    -- We only send usergroups controlled by Advisor.
    -- Others come from other admin mods and are registered on both client/servers anyway (CAMI)
    net.Start("Advisor.ClientSendUsergroups")
        for i = 1, #Advisor.Permissions.Usergroups do
            local group = Advisor.Permissions.Usergroups[i]
            if group:IsControlledByAdvisor() then
                net.WriteBool(true)
                Replicate.WriteTable(group)
            end
        end

        -- Means there's no more usergroups to read.
        net.WriteBool(false)
    net.Send(ply)
end

hook.Add("Advisor.PlayerReady", "Advisor.SynchronizeUsergroups", SynchronizeClientUsergroups)

local function OnUsergroupsRetrieved(success, message, results, affectedRows)
    if not success then 
        Advisor.Log.Error(LogSQL, "Failed to retrieve usergroups and permissions with error: %s", message)
        return 
    end

    for i = 1, #results do
        -- Check if the name row is in the Usergroups table. If not, we'll add it right now.
        local data = results[i]
        if not Advisor.Permissions.Usergroups[data["name"]] then
            local newGroup = Advisor.Usergroup(data)
            Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = newGroup
            Advisor.Permissions.UsergroupMap[newGroup:GetName()] = newGroup

            -- Check that the usergroup isn't in CAMI already.
            -- If it is, flag it as partial_control
            local registeredGroup = CAMI.GetUsergroup(newGroup:GetName()) 
            if registeredGroup and registeredGroup.CAMI_Source ~= Advisor.Source then
                newGroup:SetPartialControl(true)
                newGroup:SetSource(registeredGroup.CAMI_Source or "Unknown")
            end

            -- Notify CAMI of the newly added usergroup.
            if not Advisor.Permissions.DefaultUsergroups[newGroup:GetName()] then
                CAMI.RegisterUsergroup(newGroup:GetCAMIUsergroup(), Advisor.Source)
            end
        end

        -- Apply permission if there is one.
        if data["permission"] then
            local group = Advisor.Permissions.UsergroupMap[data["name"]]
            group:SetPermission(data["permission"], data["value"] ~= "0")
        end
    end

    -- Grab all usergroups registered on CAMI
    local camiGroups = CAMI.GetUsergroups()
    for i = 1, #camiGroups do
        local camiGroup = camiGroups[i]
        if not Advisor.Permissions.Usergroups[camiGroup.Name] then
            local thirdPartyGroup = Advisor.Usergroup()
            thirdPartyGroup:SetName(camiGroup.Name)
            thirdPartyGroup:SetInherits(camiGroup.Inherits)
            thirdPartyGroup:SetSource(camiGroup.CAMI_Source or "Unknown")

            Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = thirdPartyGroup
            Advisor.Permissions.UsergroupMap[camiGroup.Name] = thirdPartyGroup
        end
    end

    local group = Advisor.Usergroup()
    group:SetName("moderator")
    group:SetInherits("vip")
    group:SetSource(Advisor.Source)
    
    local otherGroup = Advisor.Usergroup()
    otherGroup:SetName("vip")
    otherGroup:SetInherits("user")
    otherGroup:SetSource(Advisor.Source)

    Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = group
    Advisor.Permissions.UsergroupMap["moderator"] = group
    Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = otherGroup
    Advisor.Permissions.UsergroupMap["vip"] = otherGroup

    -- TODO: Broadcast usergroups to all players. Normally this shouldn't ever happen, as this is called before players even get to join.
    -- But you never know. 
    SynchronizeClientUsergroups(player.GetAll())
end

local function InitializeUsergroups()
    local query =
    [[
        -- Add the user, admin and superadmin usergroups if they've been forcefully deleted, or just don't exist yet.
        INSERT INTO advisor_usergroups(name, display_name, color, can_delete, inherits)
        SELECT 'user', 'User', 4294967295, 0, 'user'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='user');

        INSERT INTO advisor_usergroups(name, display_name, color, can_delete, inherits)
        SELECT 'admin', 'Administrator', 4294967295, 0, 'user'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='admin');

        INSERT INTO advisor_usergroups(name, display_name, color, can_delete, inherits)
        SELECT 'superadmin', 'Super Administrator', 4294967295, 0, 'admin'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='superadmin');

        -- Sanity check, they cannot be deleted.
        UPDATE advisor_usergroups
        SET can_delete = 0
        WHERE name = 'user' OR name = 'admin' OR name = 'superadmin';

        SELECT * FROM advisor_usergroups
        LEFT JOIN advisor_usergroup_permissions USING(name);
    ]]

    Advisor.SQL.Database:query(query, {}, OnUsergroupsRetrieved)
end

if Advisor.SQL and Advisor.SQL.IsInitialized then
    if #Advisor.Permissions.Usergroups == 0 then
        InitializeUsergroups()
    end
else
    hook.Add("Advisor.DatabaseReady", "Advisor.InitializePermissions", InitializeUsergroups)
end