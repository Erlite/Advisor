local PANEL = {}

AccessorFunc(PANEL, "CornerRadius", "CornerRadius", FORCE_NUMBER)
AccessorFunc(PANEL, "TextColor", "TextColor")
AccessorFunc(PANEL, "HighlightColor", "HighlightColor")
AccessorFunc(PANEL, "CursorColor", "CursorColor")
AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "IdleAccentColor", "IdleAccentColor")
AccessorFunc(PANEL, "SelectedAccentColor", "SelectedAccentColor")
AccessorFunc(PANEL, "AdvisorTooltip", "AdvisorTooltip", FORCE_STRING)
AccessorFunc(PANEL, "AdvisorTooltipDirection", "AdvisorTooltipDirection", FORCE_NUMBER)


function PANEL:Init()
    self:SetCornerRadius(Advisor.Theme.TextEntry.CornerRadius)
    self:SetTextColor(Advisor.Theme.TextEntry.TextColor)
    self:SetHighlightColor(Advisor.Theme.TextEntry.HighlightColor)
    self:SetCursorColor(Advisor.Theme.TextEntry.CursorColor)
    self:SetBackgroundColor(Advisor.Theme.TextEntry.BackgroundColor)
    self:SetIdleAccentColor(Advisor.Theme.TextEntry.IdleAccentColor)
    self:SetSelectedAccentColor(Advisor.Theme.TextEntry.SelectedAccentColor)

    self:SetFont("Advisor:Rubik.TextEntry")
    self:SetHeight(32)
end

function PANEL:Paint(w, h)
    local radius = self:GetCornerRadius()
    local accent = (self:IsEditing() and self:IsEnabled()) and self:GetSelectedAccentColor() or self:GetIdleAccentColor()

    if radius > 0 then
        draw.RoundedBox(radius, 0, 0, w, h, accent)
        draw.RoundedBox(radius, 1, 1, w - 2, h - 2, self:GetBackgroundColor())
    else
        surface.SetDrawColor(self:GetBackgroundColor())
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(accent)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
    self:DrawTextEntryText(self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor())
end

function PANEL:Think()
    if self:IsHovered() then
        self:SetCursor(self:IsEnabled() and "beam" or "no")
    end
end

function PANEL:OnFocusChanged(gained)
    if gained then
        self:SetCaretPos(#self:GetText())
    end
end

vgui.Register("Advisor.TextEntry", PANEL, "DTextEntry")