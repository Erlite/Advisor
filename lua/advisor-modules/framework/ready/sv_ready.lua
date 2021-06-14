util.AddNetworkString("Advisor.ServerPlayerReady")
local plyMeta = FindMetaTable("Player")

function plyMeta:SetAdvisorReady(value)
    self.advisor_ready = value
end

function plyMeta:IsAdvisorReady()
    return self:IsBot() or self.advisor_ready == true
end

local function OnPlayerReady(len, ply)
    -- Ignore if the player is already ready.
    if ply:IsAdvisorReady() then return end

    Advisor.Log.Info(LogNet, "Player '%s' finished connecting.", ply:Nick())

    ply:SetAdvisorReady(true)

    hook.Run("Advisor.PlayerReady", ply)
end

net.Receive("Advisor.ServerPlayerReady", OnPlayerReady)