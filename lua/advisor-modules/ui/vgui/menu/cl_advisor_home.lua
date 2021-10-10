local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor(Color(255,0,0))
end

vgui.Register("Advisor.Menu.Home", PANEL, "Advisor.Panel")