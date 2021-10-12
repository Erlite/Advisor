Advisor = Advisor or {}
Advisor.UserManagement = Advisor.UserManagement or {}

local players = {}

util.AddNetworkString("Advisor.BroadcastPlayerConnected")

local function OnPlayerDataCreated(success, message, result, affectedRows)
    if success then
        Advisor.Log.Info(LogSQL, "Saved player data to database.")
    else
        Advisor.Log.Error(LogSQL, "Failed to upsert player data with %s", message)
    end
end

-- Callback from SetupPlayerData
local function OnPlayerDataRetrieved(success, message, result, affectedRows, params)
    if not success then
        Advisor.Log.Error(LogSQL, "Failed to retrieve player data with %s", message)
        return 
    end

    local user = result[1]
    local ply = player.GetBySteamID64(params["steamid64"])
    if not ply then return end

    -- Update or insert the player data.
    local query

    if user then 
        query =
        [[
            UPDATE 'advisor_users'
            SET last_seen = {{time}}
            WHERE steamid64 = {{steamid64}}
        ]]
    else
        query =
        [[
            INSERT INTO 'advisor_users' (steamid64, joined_at, last_seen)
            VALUES ({{steamid64}}, {{time}}, {{time}})
        ]]
    end

    local params = 
    {
        ["time"] = os.time(),
        ["steamid64"] = ply:SteamID64(),
    }

    Advisor.SQL.Database:query(query, params, OnPlayerDataCreated)

    local timestamp = 0
    if user then
        setmetatable(user, Advisor.User)
        timestamp = os.time() - user:GetLastSeenAt()
        Advisor.Log.Info(LogAdvisor, "User '%s' joined, last seen %s ago.", ply:Nick(), 
            Advisor.Utils.TimestampToReadableText(timestamp))
    else
        Advisor.Log.Info(LogSQL, "User '%s' connected for the first time.", ply:Nick())
        user = Advisor.User()
        user:SetSteamID64(ply:SteamID64())
        user:SetJoinedAt(params["time"])
        user:SetLastSeenAt(params["time"])
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

    local query = 
    [[
        SELECT * FROM 'advisor_users' 
        WHERE steamid64={{steamid64}};
    ]]

    local params = 
    {
        ["steamid64"] = ply:SteamID64(),
    }

    Advisor.SQL.Database:query(query, params, function(s, m, r, a)
        OnPlayerDataRetrieved(s, m, r, a, params)
    end)
end

hook.Add("Advisor.PlayerReady", "AdvisorSetupPlayerData", SetupPlayerData)

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