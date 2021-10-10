local PANEL = {}

function PANEL:Init()
    self:SetTitle("Advisor")
    self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self:SetMinWidth(ScrW() * 0.5)
    self:SetMinHeight(ScrH() * 0.5)
    self:SetScreenLock(true) 
    self:Center()
    self:SetDeleteOnClose(true)
    self:SetSizable(true)

    self.Categories = vgui.Create("Advisor.ScrollPanel", self)
    self.Categories:Dock(LEFT)
    self.Categories:SetWidth(ScrW() * 0.1)
end

vgui.Register("Advisor.Menu", PANEL, "Advisor.Window")