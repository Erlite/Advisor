local LOC = Advisor.Localization.Localize

local function OnPlayerConnected(len)
    local ply = net.ReadEntity(ply)
    local span = net.ReadUInt(32)

    if not ply or not ply:IsPlayer() then return end

    -- New user, just use the new user prompt.
    if span == 0 then
        chat.AddText(LOC("users", "new_user_connected", ply:Nick()))
        return
    end

    local str = Advisor.Utils.TimestampToReadableText(span)    
    chat.AddText(LOC("users", "existing_user_connected", ply:Nick(), str))
end

net.Receive("Advisor.BroadcastPlayerConnected", OnPlayerConnected)