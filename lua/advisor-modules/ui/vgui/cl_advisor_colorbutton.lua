local PANEL = {}

AccessorFunc(PANEL, "AdvisorTooltip", "AdvisorTooltip", FORCE_STRING)
AccessorFunc(PANEL, "AdvisorTooltipDirection", "AdvisorTooltipDirection", FORCE_NUMBER)


function PANEL:Init()
    self:SetColor(Color(255, 255, 255, 255), true)
    self:SetTooltip(false)
end

function PANEL:ShowPicker(value)

end

function PANEL:GetEmpty()
    return self:GetColor() == Color(0, 0, 0, 0)
end

function PANEL:SetEmpty(value)
    if value then self:SetColor(Color(0, 0, 0, 0)) end
end

function PANEL:Paint(w, h)
    local corner = Advisor.Theme.ColorButton.CornerRadius

    if self:GetEmpty() then
        surface.SetDrawColor(Advisor.Theme.ColorButton.EmptyOutlineColor)
        surface.DrawOutlinedRect(0, 0, w, h, 1)

        local x = 0
        local y = 0

        -- Courtesy of https://github.com/MysteryPancake/GMod-Rainbow/
        for i = x, x + w - 1 do
            for j = y, y + h - 1 do
                surface.SetDrawColor( ( i - x ) / w * 255, ( j - y ) / h * 255, 255 - ( ( i - x ) / w * 255 ), 255 )
                surface.DrawRect( i, j, 1, 1 )
            end
        end
    else
        draw.RoundedBox(corner, 1, 1, w - 2, h - 2, self:GetColor())
    end
end

function PANEL:PerformLayout(w, h)

end

vgui.Register("Advisor.ColorButton", PANEL, "DColorButton")