Advisor = Advisor or {}
Advisor.Infraction = {}
Advisor.Infraction.__index = Advisor.Infraction

Advisor.InfractionType = 
{
    Invalid = 0,
    Note = 1,
    Warn = 2,
    Mute = 3,
    Gag = 4,
    Kick = 5,
    Ban = 6,
}

function Advisor.Infraction.new()
    local tbl = 
    {
        user_steamid64 = nil,
        issuer_steamid64 = nil,
        type = 0,
        reason = nil,
        issued_at = nil,
        expires_at = nil,
    }

    setmetatable(tbl, Advisor.Infraction)
    return tbl
end

AccessorFunc(Advisor.Infraction, "user_steamid64", "UserSteamID64", FORCE_STRING)
AccessorFunc(Advisor.Infraction, "issuer_steamid64", "IssuerSteamID64", FORCE_STRING)
AccessorFunc(Advisor.Infraction, "type", "Type", FORCE_NUMBER)
AccessorFunc(Advisor.Infraction, "reason", "Reason", FORCE_STRING)
AccessorFunc(Advisor.Infraction, "issued_at", "IssueDate")
AccessorFunc(Advisor.Infraction, "expires_at", "ExpiryDate")

function Advisor.Infraction:GetReplicatedProperties(rt)
    rt:AddString("user_steamid64")
    rt:AddString("issuer_steamid64")
    rt:AddUInt("type", 3)
    rt:AddString("reason")
    rt:AddUInt("issued_at", 32)

    -- Only replicate the expiry date if there is one - most infractions won't have one.
    rt:AddUInt("expires_at", 32)    
      :SetReplicationCondition(function(tbl) return tbl:GetExpiryDate() ~= nil end)
end

setmetatable(Advisor.Infraction, {__call = Advisor.Infraction.new})
Replicate.SetupMetaTable(Advisor.Infraction, "Advisor.Infraction")