local PANEL = {}

function PANEL:Init()
    self:AddOption(vgui.Create("Advisor.MenuCategory")):SetCategoryName("LANDING PAGE")
    local home = self:AddOption(vgui.Create("Advisor.MenuOption"))
    home:SetOptionName("Home")
    home:SetIcon(0xf015)

    local profile = self:AddOption(vgui.Create("Advisor.MenuOption"))
    profile:SetOptionName("My Profile")
    profile:SetIcon(0xf007)

    local users = self:AddOption(vgui.Create("Advisor.MenuOption"))
    users:SetOptionName("Users")
    users:SetIcon(0xf0c0)

    local vbar = self:GetVBar()
    vbar:SetHideButtons(true)

    function vbar:Paint(w, h)
        surface.SetDrawColor(Advisor.Theme.ScrollPanel.VerticalBar)
        surface.DrawRect(0, 0, w, h)
    end

    function vbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(Advisor.Theme.ScrollPanel.VerticalGrip)
        surface.DrawRect(0, 0, w, h)
    end 
end

function PANEL:AddOption(panel)
    self:AddItem(panel)
    panel.ScrollPanel = self
    return panel
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Advisor.Theme.ScrollPanel.Background)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:UpdateSelection(selection)
    for _, child in ipairs(self:GetCanvas():GetChildren()) do
        child:SetSelected(child == selection)
    end
end

vgui.Register("Advisor.ScrollPanel", PANEL, "DScrollPanel")