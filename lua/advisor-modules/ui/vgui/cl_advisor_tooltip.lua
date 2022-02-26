local PANEL = {}

function PANEL:Init()
    self:DockPadding(8, 8, 8, 8)

    self.DisplayText = vgui.Create("DLabel", self)
    self.DisplayText:Dock(FILL)
    self.DisplayText:SetContentAlignment(5)
    self.DisplayText:SetFont("Advisor:Rubik.TextEntry")
    self.DisplayText:SetTextColor(Advisor.Theme.Tooltip.TextColor)

    hook.Add("Think", self, self.PermanentThink)

    self:MakePopup()
    self:SetMouseInputEnabled(false)
end

function PANEL:GetCurrentTooltip()
    return self.CurrentTooltip
end

function PANEL:SetCurrentTooltip(tooltip)
    if not isstring(tooltip) or #tooltip == 0 then
        self.CurrentTooltip = ""
        self:SetVisible(false)
        return
    end

    self.CurrentTooltip = tooltip
    self.DisplayText:SetText(tooltip)
    self.DisplayText:SizeToContents()
    self:InvalidateLayout()
    self:SizeToChildren(true, true)
    self:SetVisible(true)
end

function PANEL:GetTooltipBlockerCount()
    return self.blockers or 0
end

function PANEL:AddTooltipBlocker()
    if not self.blockers then
        self.blockers = 1
        return
    end

    self.blockers = self.blockers + 1
end

function PANEL:RemoveTooltipBlocker()
    if not self.blockers then return end

    self.blockers = math.max(self.blockers - 1, 0)
end

function PANEL:Paint(w, h)
    local corner = Advisor.Theme.Tooltip.CornerRadius
    draw.RoundedBox(corner, 0, 0, w, h, Advisor.Theme.Tooltip.OutlineColor)
    draw.RoundedBox(corner, 1, 1, w - 2, h - 2, Advisor.Theme.Tooltip.BackgroundColor)
end

function PANEL:PermanentThink()
    if self:GetTooltipBlockerCount() > 0 then
        self:SetVisible(false)
        return
    end

    local hoveredPanel = vgui.GetHoveredPanel()
    if IsValid(hoveredPanel) then
        local advisorTooltip = isfunction(hoveredPanel.GetAdvisorTooltip) and hoveredPanel:GetAdvisorTooltip() or nil

        if isstring(advisorTooltip) then
            self:SetCurrentTooltip(advisorTooltip)

            local preferredDirection = TOP
            if isfunction(hoveredPanel.GetAdvisorTooltipDirection) then
                preferredDirection = math.Clamp(isnumber(hoveredPanel:GetAdvisorTooltipDirection()) and hoveredPanel:GetAdvisorTooltipDirection() or TOP, LEFT, BOTTOM)
            end

            local panelX, panelY = hoveredPanel:LocalToScreen(0, 0)

            -- Calculate the tooltip's position based on preferredDirection
            if preferredDirection == TOP then
                panelX = panelX + (hoveredPanel:GetWide() / 2) - (self:GetWide() / 2)
                panelY = panelY - (10 + self:GetTall())
            elseif preferredDirection == LEFT then
                panelX = panelX - 10 - self:GetWide()
                panelY = panelY + (hoveredPanel:GetTall() / 2) - (self:GetTall() / 2)
            elseif preferredDirection == RIGHT then
                panelX = panelX + 10 + hoveredPanel:GetWide()
                panelY = panelY + (hoveredPanel:GetTall() / 2) - (self:GetTall() / 2)
            else
                panelX = panelX + (hoveredPanel:GetWide() / 2) - (self:GetWide() / 2)
                panelY = panelY + (10 + hoveredPanel:GetTall())
            end

            self:SetPos(panelX, panelY)
            self:MoveToFront()
        else
            self:SetCurrentTooltip("")
        end
    else
        self:SetCurrentTooltip("")
    end
end

vgui.Register("Advisor.Tooltip", PANEL, "Panel")