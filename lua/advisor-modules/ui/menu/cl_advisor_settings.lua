local PANEL = {}

function PANEL:Init()  
    self.FontSizeConvar = GetConVar("advisor_text_scale")

    self.FontSizeSlider = vgui.Create("DNumSlider", self)
    self.FontSizeSlider:SetSize(50, 50)
    self.FontSizeSlider:SetText("Font size")
    self.FontSizeSlider:SetMin(self.FontSizeConvar:GetMin())
    self.FontSizeSlider:SetMax(self.FontSizeConvar:GetMax())
    self.FontSizeSlider:SetConVar("advisor_text_scale")
end

function PANEL:PerformLayout(w, h)
    self.FontSizeSlider:Dock(TOP)
end

vgui.Register("Advisor.Menu.Settings", PANEL, "Advisor.Panel")