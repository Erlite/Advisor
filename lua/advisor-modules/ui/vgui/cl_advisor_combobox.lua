local PANEL = {}

function PANEL:Paint(w, h)
    local cornerRadius = Advisor.Theme.ComboBox.CornerRadius

    if self:HasFocus() then
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Advisor.Theme.ComboBox.OutlineColor)
        draw.RoundedBox(cornerRadius, 1, 1, w - 2, h - 2, Advisor.Theme.ComboBox.BackgroundColor)
    else
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Advisor.Theme.ComboBox.BackgroundColor)
    end
end

vgui.Register("Advisor.ComboBox", PANEL, "DComboBox")