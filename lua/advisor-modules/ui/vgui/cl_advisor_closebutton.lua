local PANEL = {}

AccessorFunc(PANEL, "RoundedCorners", "RoundedCorners")
AccessorFunc(PANEL, "CornerRadius", "CornerRadius", FORCE_NUMBER)
GetterFunc(PANEL, "isDepressed", "Depressed")

function PANEL:Init()
    self.RoundedCorners = { false, true, false, false }
    self.CornerRadius = 2

    self.Colors = Advisor.Theme.Button.Close

    -- Time it takes to lerp from a color to another.
    self.LerpDuration = 1

    self:SetFont("Advisor:SmallAwesome")
    self:SetText(utf8.char(0xf00d))
    self:SetTextColor(Color(255, 255, 255))

    if IsValid(self:GetParent()) then 
        local size = self:GetParent():GetTall()
        self:SetSize(size, size)
    else
        self:SetSize(32, 32)
    end
end

function PANEL:Paint(w, h)

    -- Calculate the new color to display.
    local color = not self:IsEnabled() and self.Colors.Disabled
        or self:IsHovered() and self.Colors.Hovered
        or self:GetDepressed() and self.Colors.Pressed
        or self.Colors.Idle

    local r = self.RoundedCorners

    draw.RoundedBoxEx(self.CornerRadius, 0, 0, w, h, color, r[1], r[2], r[3], r[4])
end

function PANEL:OnDepressed()
    self.isDepressed = true
end

function PANEL:OnReleased()
    self.isDepressed = false
end

vgui.Register("Advisor.CloseButton", PANEL, "DButton")