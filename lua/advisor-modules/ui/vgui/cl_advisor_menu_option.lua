local PANEL = {}

AccessorFunc(PANEL, "IsSelected", "Selected", FORCE_BOOL)
AccessorFunc(PANEL, "BodyPanel", "BodyPanel")
AccessorFunc(PANEL, "ScrollPanel", "ScrollPanel")

function PANEL:Init()
    self:SetHeight(48)
    self:Dock(TOP)

    self.IconLabel = vgui.Create("DLabel", self)
    self.IconLabel:SetFont("Advisor.Awesome")
    self.IconLabel:Dock(LEFT)
    self.IconLabel:DockMargin(16, 0, 0, 0)
    self.IconLabel:SetContentAlignment(5)
    self.IconLabel:SetWidth(32)

    self.Label = vgui.Create("DLabel", self)
    self.Label:SetText("Option")
    self.Label:SetFont("Rubik.Body")
    self.Label:Dock(LEFT)
    self.Label:DockMargin(16, 0, 0, 0)

    self:SetSelected(false)
    self:SetIcon()
end

function PANEL:SetIcon(...)
    local icon = utf8.char(...)
    if not ... then 
        icon = utf8.char(0xf138) -- Default to chevron with right arrow
    end

    self.IconLabel:SetText(icon)
end

function PANEL:SetOptionName(name)
    self.Label:SetText(name)
    self.Label:SizeToContentsX()
end

function PANEL:Paint(w, h) 
    if self:GetSelected() then 
        surface.SetDrawColor(Advisor.Theme.MenuOption.SelectedBackground)
    elseif self:IsHovered() then 
        surface.SetDrawColor(Advisor.Theme.MenuOption.HoveredBackground)
        self:SetCursor("hand")
    else
        surface.SetDrawColor(Advisor.Theme.MenuOption.IdleBackground)
        self:SetCursor("arrow")
    end

    surface.DrawRect(0, 0, w, h)

    if self:GetSelected() then 
        surface.SetDrawColor(Advisor.Theme.MenuOption.SelectedAccent)
        surface.DrawRect(0, 0, 4, h)
    end
end

function PANEL:OnMousePressed()
    if IsValid(self.ScrollPanel) then
        self.ScrollPanel:UpdateSelection(self)
    end

    self:SetCursor("arrow")
end

vgui.Register("Advisor.MenuOption", PANEL, "EditablePanel")