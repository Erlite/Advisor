Advisor = Advisor or {}
Advisor.UI = Advisor.UI or {}
Advisor.UI.MainPanel = Advisor.UI.MainPanel or nil

local function ResetMenu()
    if IsValid(Advisor.UI.MainPanel) then
        local wasVisible = Advisor.UI.MainPanel:IsVisible()
        Advisor.UI.MainPanel:Remove()

        -- Re-open the menu if it was visible before 
        if wasVisible then
            Advisor.UI.OpenMenu()
        end
    end
end

hook.Add("OnScreenSizeChanged", "Advisor.ResetMenuOnScreenSizeChanged", ResetMenu)
concommand.Add("advisor_refreshmenu", ResetMenu, nil, "Removes Advisor's menu to allow for re-creation.")

-- Return the tooltip widget used for displaying custom UI tooltips.
-- Only one instance should exist at all times.
function Advisor.UI:GetTooltip()
    if not self.TooltipWidget then
        self.TooltipWidget = vgui.Create("Advisor.Tooltip")
    end

    return self.TooltipWidget
end

function Advisor.UI.OpenMenu()
    local LOC = Advisor.Localization.Localize

    -- Spawn a tooltip widget if we don't have one.
    Advisor.UI:GetTooltip()

    if IsValid(Advisor.UI.MainPanel) then
        if Advisor.UI.MainPanel:IsVisible() then
            Advisor.UI.MainPanel:Close()
        else
            Advisor.UI.MainPanel:Open()
        end
        return
    end

    local mp = Advisor.MenuProperty()
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_home"), vgui.Create("Advisor.Menu.Home"), utf8.char(0xf015))
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_myprofile"), vgui.Create("Advisor.Panel"), utf8.char(0xf007))
    mp:AddOption(LOC("ui", "category_landing"), LOC("ui", "option_settings"), vgui.Create("Advisor.Panel"), utf8.char(0xf013))
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_usergroups"), vgui.Create("Advisor.Menu.Usergroups"), utf8.char(0xf505))
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_users"), vgui.Create("Advisor.Panel"), utf8.char(0xf0c0))
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_auditlogs"), vgui.Create("Advisor.Panel"), utf8.char(0xf02d))
    mp:AddOption(LOC("ui", "category_admin"), LOC("ui", "option_bans"), vgui.Create("Advisor.Panel"), utf8.char(0xf0e3))
    mp:AddOption(LOC("ui", "category_misc"), LOC("ui", "option_credits"), vgui.Create("Advisor.Menu.Credits"), utf8.char(0xf004))

    hook.Run("Advisor.PopulateMenuOptions", mp)

    local res, msg = pcall(function()
        local main = vgui.Create("Advisor.Menu")
        main:PopulateOptions(mp)
        main:MakePopup()
        main:Open()
    
        Advisor.UI.MainPanel = main
    end)
    
    if not res then 
        Advisor.Log.Error(LogUI, "An error occured while opening the menu: %s", msg)
        if IsValid(Advisor.UI.MainPanel) then
            Advisor.UI.MainPanel:Remove()
        end
    end
end

net.Receive("Advisor.ClientOpenMenu", function(len, ply)
    Advisor.UI.OpenMenu()
end)