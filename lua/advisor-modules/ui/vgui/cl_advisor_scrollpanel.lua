local PANEL = {}

AccessorFunc(PANEL, "SelectedPanel", "SelectedPanel")
AccessorFunc(PANEL, "MinWidth", "MinWidth", FORCE_NUMBER)

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
    self:SetMinWidth(50)
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
    panel:SetMouseInputEnabled(true)
    
    self:AddItem(option)

    if not IsValid(self:GetSelectedPanel()) then 
        self:UpdateSelection(option)
    end

    return option
end

function PANEL:PopulateOptions(mp)
    local cats = mp:GetCategories()

    for _, cat in ipairs(cats) do
        self:AddCategory(cat.Name)

        for _, option in ipairs(cat.Children) do
            self:AddOption(option.Name, option.Panel, option.Icon and unpack(option.Icon) or nil)
        end
    end
end

function PANEL:PerformLayout(w, h)
    --  Base call
    self:PerformLayoutInternal()
 
    --  Size to children
    local maxChildWidth = self:GetMinWidth()
    for i, v in ipairs(self:GetCanvas():GetChildren()) do
        local label = v.Label or v.Name
        if not IsValid(label) then continue end

        local font = label:GetFont()
        surface.SetFont(font)
        local textWidth = surface.GetTextSize(label:GetText())
        maxChildWidth = math.max(maxChildWidth, label:GetX() * 1.5 + label:GetWide())
    end

    self:SetWidth(maxChildWidth)
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
    self:OnSelectionUpdated(selection)
end

function PANEL:OnSelectionUpdated(selection)
end

vgui.Register("Advisor.ScrollPanel", PANEL, "DScrollPanel")