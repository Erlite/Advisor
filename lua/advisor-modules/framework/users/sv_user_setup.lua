Advisor = Advisor or {}
Advisor.UserManagement = Advisor.UserManagement or {}

local players = {}

util.AddNetworkString("Advisor.BroadcastPlayerConnected")

local function UpdatePlayerData(ply)
    if not IsValid(ply) or ply:IsBot() then return end

    local query = 
    [[
        UPDATE 'advisor_users'
        SET last_seen = {{time}}
        WHERE steamid64 = {{steamid64}};
    ]]

    local params = 
    {
        ["time"] = os.time(),
        ["steamid64"] = ply:SteamID64()
    }

    Advisor.SQL.Database:query(query, params, function(success, message)
        if success then
            Advisor.Log.Info(LogSQL, "Updated player data on database.")
        else
            Advisor.Log.Error(LogSQL, "Failed to update player data with error: %s", message)
        end
    end)
end

hook.Add("PlayerDisconnected", "AdvisorUpdatePlayerLastSeenAt", UpdatePlayerData)

local function OnPlayerDataCreated(success, message, result, affectedRows)
    if not success then
        Advisor.Log.Error(LogSQL, "Failed to upsert player data with %s", message)
        return
    end

    local user = result[1]
    setmetatable(user, Advisor.User)
    local ply = player.GetBySteamID64(user:GetSteamID64())

    local timestamp = user:GetLastSeenAt() - user:GetJoinedAt()
    if timestamp > 0 then
        timestamp = os.time() - user:GetLastSeenAt()
        Advisor.Log.Info(LogAdvisor, "User '%s' joined, last seen %s ago.", ply:Nick(), 
            Advisor.Utils.TimestampToReadableText(timestamp))

        UpdatePlayerData(ply)
    else
        Advisor.Log.Info(LogSQL, "User '%s' connected for the first time.", ply:Nick())
    end

    net.Start("Advisor.BroadcastPlayerConnected")
        net.WriteEntity(ply)
        net.WriteUInt(timestamp, 32)
    net.Broadcast()

    hook.Run("Advisor.PlayerDataRetrieved", user)
end

-- Called to setup a player's profile in the database, or update it if it exists.
local function SetupPlayerData(ply)
    if not ply or ply:IsBot() then return end
    players[ply:SteamID64()] = ply

    -- Update or insert the player data.
    local query =
    [[
        INSERT INTO advisor_users
        SELECT {{steamid64}}, {{time}}, {{time}}
        WHERE NOT EXISTS (SELECT * FROM advisor_users WHERE steamid64={{steamid64}});
        
        -- Add the user's name to the aliases if it doesn't exist already.
        INSERT INTO advisor_user_aliases
        SELECT {{steamid64}}, {{name}}, {{time}}
        WHERE NOT EXISTS (SELECT * FROM advisor_user_aliases WHERE steamid64 = {{steamid64}} AND alias = {{name}});

        SELECT * FROM advisor_users
        WHERE steamid64 = {{steamid64}}
        LIMIT 1;
    ]]

    local params = 
    {
        ["time"] = os.time(),
        ["steamid64"] = ply:SteamID64(),
        ["name"] = ply:Nick(),
    }

    Advisor.SQL.Database:query(query, params, OnPlayerDataCreated)
end

hook.Add("Advisor.PlayerReady", "AdvisorSetupPlayerData", SetupPlayerData)