Advisor = Advisor or {}
Advisor.Permissions = Advisor.Permissions or {}
Advisor.Permissions.Roles = Advisor.Permissions.Roles or {}

-- local function OnPermissionsReceived(success, msg, result, affected)
--     if not success then
--         Advisor.Log.Error(LogSQL, "Failed to retrieve permissions, this is a fatal error as no permissions will be granted.")
--         Advisor.Log.Error(LogSQL, msg)
--         return
--     end

    
-- end

-- local function OnRolesReceived(success, msg, result, affected)
--     if not success then 
--         Advisor.Log.Error(LogSQL, "Failed to retrieve roles, this is a fatal error and Advisor will not function.")
--         Advisor.Log.Error(LogSQL, msg)
--         return
--     end

--     for k, role in ipairs(result) do
--         setmetatable(role, Advisor.Role)
--         Advisor.Permissions.Roles[k] = role
--     end

--     Advisor.Log.Info(LogSQL, "Successfully loaded %i role(s).", #Advisor.Permissions.Roles)
--     local rolePermissionsQuery = "SELECT * FROM 'advisor_role_permissions';" 
--     db:query(rolePermissionsQuery, {}, OnPermissionsReceived)
-- end

-- local function OnDatabaseReady()
--     -- Get all the roles
--     local roleQuery = "SELECT * FROM 'advisor_roles';"

--     local db = Advisor.SQL.Database
--     db:query(roleQuery, {}, OnRolesReceived)
-- end

-- hook.Add("Advisor.DatabaseReady", "InitializeAdvisorPerms", OnDatabaseReady)