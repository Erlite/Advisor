local PANEL = {}

AccessorFunc(PANEL, "RoundedCorners", "RoundedCorners")
AccessorFunc(PANEL, "CornerRadius", "CornerRadius", FORCE_NUMBER)
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "LerpDuration", "LerpTime", FORCE_NUMBER)
AccessorFunc(PANEL, "LerpEnabled", "LerpEnabled", FORCE_BOOL)
GetterFunc(PANEL, "isDepressed", "Depressed")

function PANEL:Init()
    self.RoundedCorners = { false, true, false, false }
    self.CornerRadius = 2

    self.Colors = Advisor.Theme.Button.Close
    self.CurrentColor = self.Colors.Idle
    self.LerpColor = self.Colors.Idle
    self.TargetColor = self.Colors.Idle

    -- Time it takes to lerp from a color to another.
    self.LerpDuration = 1

    self:SetText("✕")
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
    local newColor = self.CurrentColor
    local target = self.TargetColor

    target = not self:IsEnabled() and self.Colors.Disabled
            or self:IsHovered() and self.Colors.Hovered
            or self:GetDepressed() and self.Colors.Pressed
            or self.Colors.Idle

    local r = self.RoundedCorners

    if self:GetLerpEnabled() then
        if self.TargetColor ~= target then 
            self.CurrentColor = self.LerpColor
            self.ColorLerpStartTime = SysTime()
            self.TargetColor = target
        end

        if self.CurrentColor ~= self.TargetColor then
            local alpha = ( SysTime() - self.ColorLerpStartTime ) / self.LerpDuration
            self.LerpColor = math.LerpColor(self.CurrentColor, self.TargetColor, alpha)

            if alpha == 1.0 then 
                self.CurrentColor = self.TargetColor 
            end
        end

        draw.RoundedBoxEx(self.CornerRadius, 0, 0, w, h, self.LerpColor, r[1], r[2], r[3], r[4])
    else
        draw.RoundedBoxEx(self.CornerRadius, 0, 0, w, h, target, r[1], r[2], r[3], r[4])
    end
end

function PANEL:OnDepressed()
    self.isDepressed = true
end

function PANEL:OnReleased()
    self.isDepressed = false
end

vgui.Register("Advisor.CloseButton", PANEL, "DButton")