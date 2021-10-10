Advisor = Advisor or {}
Advisor.UI = Advisor.UI or {}
Advisor.UI.MainPanel = Advisor.UI.MainPanel or nil

function Advisor.UI.OpenMenu()
    if IsValid(Advisor.UI.MainPanel) then
        Advisor.UI.MainPanel:Remove()
        return
    end

    local mp = Advisor.MenuProperty()
    mp:AddOption("LANDING PAGE", "Home", vgui.Create("Advisor.Menu.Home"), 0xf015)
    mp:AddOption("LANDING PAGE", "My Profile", vgui.Create("Advisor.Panel"), 0xf007)
    mp:AddOption("ADMINISTRATION", "Usergroups", vgui.Create("Advisor.Panel"), 0xf505)
    mp:AddOption("ADMINISTRATION", "Users", vgui.Create("Advisor.Panel"), 0xf0c0)
    mp:AddOption("ADMINISTRATION", "Audit Logs", vgui.Create("Advisor.Panel"), 0xf02d)
    mp:AddOption("ADMINISTRATION", "Bans", vgui.Create("Advisor.Panel"), 0xf0e3)
    mp:AddOption("MISCELLANEOUS", "Credits", vgui.Create("Advisor.Panel"), 0xf004)

    hook.Run("Advisor.PopulateMenuOptions", mp)

    local main = vgui.Create("Advisor.Menu")
    main:PopulateOptions(mp)
    main:MakePopup()
    main:SlideDown(1)

    Advisor.UI.MainPanel = main
end

net.Receive("Advisor.ClientOpenMenu", function(len, ply)
    Advisor.UI.OpenMenu()
end)