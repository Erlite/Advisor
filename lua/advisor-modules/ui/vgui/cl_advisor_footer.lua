local PANEL = {}

AccessorFunc(PANEL, "Text", "Text", FORCE_STRING)

function PANEL:Init()
    self:Dock(BOTTOM)
    self:SetHeight(24)

    self:SetText("Copyright (c) 2021 Younes Meziane and Contributors. This software is licenced under the MIT Licence.")
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(Advisor.Theme.Panel.FooterBottomRadius, 0, 0, w, h, Advisor.Theme.Panel.Footer, false, false, false, true)
    draw.SimpleText(self:GetText(), "Rubik.Footer", self:GetWide() / 2, self:GetTall() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("Advisor.Footer", PANEL, "Panel")