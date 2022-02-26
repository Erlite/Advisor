local PANEL = {}

AccessorFunc(PANEL, "SelectedPanel", "SelectedPanel")

function PANEL:Init()
    local vbar = self:GetVBar()
    vbar:SetHideButtons(true)
    vbar:SetWide(8)

    function vbar:Paint(w, h)
        surface.SetDrawColor(Advisor.Theme.ScrollPanel.VerticalBar)
        surface.DrawRect(0, 0, w, h)
    end

    function vbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(Advisor.Theme.ScrollPanel.VerticalGrip)
        surface.DrawRect(0, 0, w, h)
    end 

    self:SetSelectedPanel(nil)
end

function PANEL:AddCategory(name)
    local cat = vgui.Create("Advisor.MenuCategory")
    cat:SetCategoryName(name)

    self:AddItem(cat)
end

function PANEL:AddOption(name, icon, font)
    icon = icon or ""
    font = font or "Advisor:FontAwesome"

    local option = vgui.Create("Advisor.ScrollPanelOption")
    option:SetOptionName(name)
    option:SetIcon(icon)
    option:SetIconFont(font)
    option:SetScrollPanel(self)
    
    self:AddItem(option)

    if not IsValid(self:GetSelectedPanel()) then 
        self:UpdateSelection(option)
    end

    return option
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(Advisor.Theme.ScrollPanel.BottomLeftCornerRadius, 0, 0, w, h, Advisor.Theme.ScrollPanel.Background, false, false, true, false)
end

function PANEL:UpdateSelection(selection)
    for _, child in ipairs(self:GetCanvas():GetChildren()) do
        child:SetSelected(child == selection)
    end

    self:SetSelectedPanel(selection)
    self:OnSelectionUpdated(selection)
end

function PANEL:OnSelectionUpdated(selection)
end

vgui.Register("Advisor.ScrollPanel", PANEL, "DScrollPanel")