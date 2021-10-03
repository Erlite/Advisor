Advisor = Advisor or {}
Advisor.Utils = Advisor.Utils or {}

util.AddNetworkString("Advisor.LocalizedMessage")

function Advisor.Utils.LocalizedMessage(ply, color, namespace, key, ...)
    local args = { ... }

    -- Could be an attempt to send to the console, ignoring.
    if not istable(ply) and not (IsValid(ply) and ply:IsPlayer()) then
        return
    end

    net.Start("Advisor.LocalizedMessage")
        net.WriteColor(color)
        net.WriteString(namespace)
        net.WriteString(key)
        net.WriteUInt(#args, 4)
        for _, v in ipairs(args) do
            net.WriteString(v)
        end
    net.Send(ply)
end