Advisor = Advisor or {}
Advisor.UI = Advisor.UI or {}
Advisor.UI.MainPanel = Advisor.UI.MainPanel or nil

function Advisor.UI.OpenMenu()
    if IsValid(Advisor.UI.MainPanel) then
        Advisor.UI.MainPanel:Remove()
        return
    end

    local main = vgui.Create("Advisor.Window")
    main:MakePopup()
    main:SetTitle("Advisor")

    main:SetSize(1024, 512)
    main:Center()
    main:SetDeleteOnClose(true)

    Advisor.UI.MainPanel = main
end

net.Receive("Advisor.ClientOpenMenu", function(len, ply)
    Advisor.UI.OpenMenu()
end)