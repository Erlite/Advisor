local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:DockPadding(16, 0, 0, 0)
    self:SetHeight(36)

    self.Name = vgui.Create("DLabel", self)
    self.Name:SetFont("Advisor:Rubik.Body")
    self.Name:Dock(LEFT)
    self.Name:SetContentAlignment(5)

    self:SetCategoryName("CATEGORY")
end

function PANEL:GetCategoryName()
    return self.Name:GetText()
end

function PANEL:SetCategoryName(name)
    self.Name:SetText(name)
    self.Name:SizeToContentsX()
end

function PANEL:PerformLayout(w, h)
    self.Name:SizeToContentsX()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Advisor.Theme.Category.Background)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("Advisor.MenuCategory", PANEL, "Panel")