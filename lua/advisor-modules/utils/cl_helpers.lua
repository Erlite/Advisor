Advisor = Advisor or {}
Advisor.Utils = Advisor.Utils or {}

function Advisor.Utils.LocalizedMessage(ply, color, namespace, key, ...)
    chat.AddText(color, Advisor.Localization.Localize(namespace, key, unpack({...})))
end

net.Receive("Advisor.LocalizedMessage", function(ply, len)
    local color = net.ReadColor()
    local namespace = net.ReadString()
    local key = net.ReadString()

    local count = net.ReadUInt(8)
    local args = {}
    for i = 1, count do 
        args[#args + 1] = net.ReadString()
    end

    chat.AddText(color, Advisor.Localization.Localize(namespace, key, unpack(args)))
end)