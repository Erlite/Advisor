Advisor = Advisor or {}
Advisor.Utils = Advisor.Utils or {}

util.AddNetworkString("Advisor.LocalizedMessage")

function Advisor.Utils.LocalizedMessage(ply, color, namespace, key, ...)
    local args = { ... }

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