PANEL = {}

AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor")

function PANEL:Init()
    self:Dock(FILL)
    self:SetBackgroundColor(Advisor.Theme.Panel.Background)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self:GetBackgroundColor())
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("Advisor.Panel", PANEL, "EditablePanel")