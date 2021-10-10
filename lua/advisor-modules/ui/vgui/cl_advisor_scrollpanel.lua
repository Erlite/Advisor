local PANEL = {}

AccessorFunc(PANEL, "SelectedPanel", "SelectedPanel")

function PANEL:Init()
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

    self:SetSelectedPanel(nil)
end

function PANEL:AddCategory(name)
    local cat = vgui.Create("Advisor.MenuCategory")
    cat:SetCategoryName(name)

    self:AddItem(cat)
end

function PANEL:AddOption(name, panel, icon)
    local option = vgui.Create("Advisor.MenuOption")
    option:SetOptionName(name)
    option:SetIcon(icon)
    option:SetBodyPanel(panel)
    option:SetScrollPanel(self)
    panel:SetParent(self:GetParent())
    panel:SetVisible(false)
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
    local bodyPanel = nil
    for _, child in ipairs(self:GetCanvas():GetChildren()) do
        child:SetSelected(child == selection)

        if child.GetBodyPanel and IsValid(child:GetBodyPanel()) then 
            if child == selection then 
                bodyPanel = child:GetBodyPanel()
            end
            child:GetBodyPanel():SetVisible(child == selection)
        end
    end

    self:SetSelectedPanel(selection)

    local footer = self:GetParent().Footer

    if IsValid(footer) then
        if IsValid(bodyPanel) then
            footer:SetParent(bodyPanel)
        else
            bodyPanel = self:GetParent().Body
            footer:SetParent(bodyPanel)
            bodyPanel:SetVisible(true)
        end
    end
end

vgui.Register("Advisor.ScrollPanel", PANEL, "DScrollPanel")