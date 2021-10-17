Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}
Advisor.Permissions.Usergroups = Advisor.Permissions.Usergroups or {}

local function OnUsergroupsRetrieved(success, message, result, affectedRows)
    PrintTable(result)
end

local function InitializeUsergroups()
    local query =
    [[
        -- Add the user, admin and superadmin usergroups if they've been forcefully deleted, or just don't exist yet.
        INSERT INTO advisor_usergroups
        SELECT 'user', 'User', 4294967295, 0, 'user'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='user');

        INSERT INTO advisor_usergroups
        SELECT 'admin', 'Administrator', 4294967295, 0, 'user'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='admin');

        INSERT INTO advisor_usergroups
        SELECT 'superadmin', 'Super Administrator', 4294967295, 0, 'admin'
        WHERE NOT EXISTS (SELECT * FROM advisor_usergroups WHERE name='superadmin');

        -- Sanity check, they cannot be deleted.
        UPDATE advisor_usergroups
        SET can_delete = 0
        WHERE name = 'user' OR name = 'admin' OR name = 'superadmin';

        SELECT * FROM advisor_usergroups
        LEFT JOIN advisor_usergroup_permissions ON advisor_usergroups.name = advisor_usergroup_permissions.usergroup_name;
    ]]

    Advisor.SQL.Database:query(query, {}, OnUsergroupsRetrieved)
end

if Advisor.SQL.IsInitialized then
    InitializeUsergroups()
else
    hook.Add("Advisor.DatabaseReady", "Advisor.InitializePermissions", InitializeUsergroups)
end