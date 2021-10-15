local PANEL = {}

AccessorFunc(PANEL, "RoundedCorners", "RoundedCorners")
AccessorFunc(PANEL, "CornerRadius", "CornerRadius", FORCE_NUMBER)
AccessorFunc(PANEL, "isDepressed", "Depressed", FORCE_BOOL)
AccessorFunc(PANEL, "IdleColor", "IdleColor")
AccessorFunc(PANEL, "HoveredColor", "HoveredColor")
AccessorFunc(PANEL, "PressedColor", "PressedColor")
AccessorFunc(PANEL, "DisabledColor", "DisabledColor")

function PANEL:Init()
    self:SetRoundedCorners(Advisor.Theme.Button.RoundedCorners)
    self:SetCornerRadius(Advisor.Theme.Button.CornerRadius)
    self:SetIdleColor(Advisor.Theme.Button.Default.Idle)
    self:SetHoveredColor(Advisor.Theme.Button.Default.Hovered)
    self:SetPressedColor(Advisor.Theme.Button.Default.Pressed)
    self:SetDisabledColor(Advisor.Theme.Button.Default.Disabled)

    self:SetMouseInputEnabled(true)

    self.DisplayText = vgui.Create("DLabel", self)
    self.DisplayText:SetContentAlignment(5)
    self.DisplayText:SetFont("Advisor:Rubik.Button")

    self.IconText = vgui.Create("DLabel", self)
    self.IconText:SetText( "" )
    self.IconText:SetFont("Advisor:Awesome")
    self.IconText:SetContentAlignment(5)

    self:SetText("Button")
    self:SetHeight(32)
end

function PANEL:PerformLayout(w, h)
    local icon_width = 0
    if ( #self:GetIcon() > 0 ) then
        icon_width = self.IconText:GetWide() + Advisor.Theme.Button.IconMargin
        self.IconText:SetPos( w / 2 - ( icon_width + self.DisplayText:GetWide() ) / 2, h / 2 - self.IconText:GetTall() / 2 )    
    end

    self.DisplayText:SetPos( w / 2 - ( self.DisplayText:GetWide() - icon_width ) / 2, h / 2 - self.DisplayText:GetTall() / 2 )
end

function PANEL:Paint(w, h)
    local color = self:GetIdleColor()

    if not self:IsEnabled() then 
        self:SetCursor("no")
        color = self:GetDisabledColor()
    elseif self:GetDepressed() then 
        self:SetCursor("hand")
        color = self:GetPressedColor()
    elseif self:IsHovered() then
        self:SetCursor("hand")
        color = self:GetHoveredColor()
    else
        self:SetCursor("arrow")
    end

    local rounded = self:GetRoundedCorners()

    draw.RoundedBox(self:GetCornerRadius(), 0, 0, w, h, color, rounded[1], rounded[2], rounded[3], rounded[4])
end

function PANEL:GetText()
    return self.DisplayText:GetText()
end

function PANEL:SetText(text)
    self.DisplayText:SetText(text)
    self.DisplayText:SizeToContentsX()
end

function PANEL:GetIcon()
    return self.IconText:GetText()
end

function PANEL:SetIcon(...)
    local icon = utf8.char(...)
    if not ... then 
        icon = utf8.char(0xf138) -- Default to chevron with right arrow
    end

    self.IconText:SetText(icon)
    self.IconText:SizeToContentsX()
end

function PANEL:OnMousePressed()
    self:SetDepressed(true)
end

function PANEL:OnMouseReleased()
    self:SetDepressed(false)

    if self:IsHovered() then 
        self:DoClick()
    end
end

function PANEL:DoClick() end

function PANEL:UpdateColors(tbl)
    self:SetIdleColor(tbl.Idle)
    self:SetHoveredColor(tbl.Hovered)
    self:SetPressedColor(tbl.Pressed)
    self:SetDisabledColor(tbl.Disabled)
end

vgui.Register("Advisor.Button", PANEL, "EditablePanel")