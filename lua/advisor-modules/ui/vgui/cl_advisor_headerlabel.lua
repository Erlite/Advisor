local PANEL = {}

function PANEL:Init()
    self:SetFont(Advisor.Theme.TitleBar.Font)
    self:Dock(LEFT)
end

vgui.Register("Advisor.HeaderLabel", PANEL, "DLabel")