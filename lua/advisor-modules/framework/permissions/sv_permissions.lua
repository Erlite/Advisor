Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}

local function OnDatabaseReady()
    -- Get all the roles
    local roleQuery = "SELECT * FROM 'advisor_roles';"
    local rolePermissionsQuery = "SELECT * FROM 'advisor_role_permissions';" 
end

hook.Add("Advisor.DatabaseReady", "InitializeAdvisorPerms", OnDatabaseReady)