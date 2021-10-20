Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}
Advisor.Permissions.Usergroups = Advisor.Permissions.Usergroups or {}
Advisor.Permissions.UsergroupMap = Advisor.Permissions.UsergroupMap or {}

net.Receive("Advisor.ClientSendUsergroups", function(ply, len)
    -- Unregister old usergroups if any.
    for _, oldGroup in ipairs(Advisor.Permissions.Usergroups) do
        if not Advisor.Permissions.DefaultUsergroups[oldGroup:GetName()] and oldGroup:GetSource() == Advisor.Source and not oldGroup:GetPartialControl() then
            CAMI.UnregisterUsergroup(oldGroup:GetCAMIUsergroup(), Advisor.Source)
        end
    end

    Advisor.Permissions.Usergroups = {}
    Advisor.Permissions.UsergroupMap = {}

    while (net.ReadBool()) do
        local group = Replicate.ReadTable(Advisor.Usergroup)
        if group then
            Advisor.Permissions.Usergroups[#Advisor.Permissions.Usergroups + 1] = group
            Advisor.Permissions.UsergroupMap[group:GetName()] = group
        end

        if not Advisor.Permissions.DefaultUsergroups[group:GetName()] then
            CAMI.RegisterUsergroup(group:GetCAMIUsergroup(), Advisor.Source)
        end
    end

    -- Add any registered CAMI group.
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

    Advisor.Log.Info(LogAdvisor, "Received %i usergroup(s) from the server.", #Advisor.Permissions.Usergroups)
    hook.Run("Advisor.OnUsergroupsUpdated")
end)