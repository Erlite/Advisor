Advisor = Advisor or {}
Advisor.UI = Advisor.UI or {}
Advisor.UI.MainPanel = Advisor.UI.MainPanel or nil

local function ResetMenu()
    if IsValid(Advisor.UI.MainPanel) then
        Advisor.UI.MainPanel:Remove()
    end
end
concommand.Add("advisor_refreshmenu", ResetMenu, nil, "Removes Advisor's menu to allow for re-creation.")

function Advisor.UI.OpenMenu()
    local LOC = Advisor.Localization.Localize

    if IsValid(Advisor.UI.MainPanel) then
        if Advisor.UI.MainPanel:IsVisible() then
            Advisor.UI.MainPanel:Close()
        else
            Advisor.UI.MainPanel:Open()
            Advisor.UI.MainPanel:SlideDown(0.5)
        end
        return
    end

    local mp = Advisor.MenuProperty()
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_home"), vgui.Create("Advisor.Menu.Home"), 0xf015)
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_myprofile"), vgui.Create("Advisor.Panel"), 0xf007)
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_settings"), vgui.Create("Advisor.Panel"), 0xf013)
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_usergroups"), vgui.Create("Advisor.Panel"), 0xf505)
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_users"), vgui.Create("Advisor.Panel"), 0xf0c0)
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_auditlogs"), vgui.Create("Advisor.Panel"), 0xf02d)
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_bans"), vgui.Create("Advisor.Panel"), 0xf0e3)
    mp:AddOption(LOC("ui", "category_misc"), LOC("ui", "option_credits"), vgui.Create("Advisor.Menu.Credits"), 0xf004)

    hook.Run("Advisor.PopulateMenuOptions", mp)

    local main = vgui.Create("Advisor.Menu")
    main:PopulateOptions(mp)
    main:MakePopup()
    main:SlideDown(0.5)

    Advisor.UI.MainPanel = main
end

net.Receive("Advisor.ClientOpenMenu", function(len, ply)
    Advisor.UI.OpenMenu()
end)