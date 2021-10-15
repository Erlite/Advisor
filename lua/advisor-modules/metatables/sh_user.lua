Advisor = Advisor or {}
Advisor.User = {}
Advisor.User.__index = Advisor.User

-- Create a new user object from 
function Advisor.User.new(self, ply)
    if not IsValid(ply) or not isentity(ply) or not ply:IsPlayer() then
        error("Advisor.User can only be created from a valid player.")
    end

    local tbl = 
    {
        steamid64 = ply:SteamID64(),
        joined_at = os.time(),
        last_seen = os.time(),
    }

    setmetatable(tbl, Advisor.User)
    return tbl
end

AccessorFunc(Advisor.User, "steamid64", "SteamID64", FORCE_STRING)
AccessorFunc(Advisor.User, "joined_at", "JoinedAt", FORCE_NUMBER)
AccessorFunc(Advisor.User, "last_seen", "LastSeenAt", FORCE_NUMBER)

function Advisor.User:GetReplicatedProperties(rt)
    rt:AddString("steamid64")
    rt:AddUInt("joined_at", 32)
    rt:AddUInt("last_seen", 32)
end

function Advisor.User:IsValid()
    return isstring(self:GetSteamID64()) 
        and isnumber(self:GetJoinedAt()) 
        and isnumber(self:GetLastSeenAt())
end

setmetatable(Advisor.User, {__call = Advisor.User.new})
Replicate.SetupMetaTable(Advisor.User, "Advisor.User")