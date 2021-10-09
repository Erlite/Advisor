Advisor = Advisor or {}
Advisor.UI = Advisor.UI or {}

util.AddNetworkString("Advisor.ClientOpenMenu")

function Advisor.UI.ClientOpenMenu(ply)
    net.Start("Advisor.ClientOpenMenu")
    net.Send(ply)
end