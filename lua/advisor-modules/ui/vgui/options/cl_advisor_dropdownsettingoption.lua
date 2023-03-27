local PANEL = {}

AccessorFunc(PANEL, "Spacing", "Spacing", FORCE_NUMBER)
AccessorFunc(PANEL, "Seperator", "Seperator", FORCE_BOOL)

function PANEL:Init()
    self.Title = vgui.Create("DLabel", self)
    self.Title:Dock(NODOCK)
    self.Title:SetFont("Advisor:Rubik.OptionTitle")
    self.Title:SetText("Name")
    self.Title:SizeToContents()

    self.ComboBox = vgui.Create("Advisor.ComboBox", self)
    self.ComboBox:Dock(NODOCK)
    self.ComboBox:SetTall(32)
    self.ComboBox:SetFont("Advisor:Rubik.TextEntry")
    self.ComboBox:SetTextColor(Color(255, 255, 255))

    self.Description = vgui.Create("DLabel", self)
    self.Description:Dock(NODOCK)
    self.Description:SetFont("Advisor:Rubik.OptionDescription")
    self.Description:SizeToContents()

    self:SetDescription("This is the description for this setting. It can be disabled.")
    self:SetSpacing(4)
    self:SetSeperator(true)
end

-- Override and call to update the displayed data.
function PANEL:UpdateDisplayedData() end

function PANEL:SetTitle(title)
    self.Title:SetText((title and #title ~= 0) and title or "Invalid Title")
    self.Title:SizeToContents()
end

function PANEL:SetDescription(desc)
    self.Description:SetText(desc or "")
    self.Description:SizeToContents()
    self.Description:SetVisible(desc and #desc > 0)
end

function PANEL:Paint(w, h)
    if self:GetSeperator() then
        surface.SetDrawColor(Advisor.Theme.SettingOption.SeparatorColor)
        surface.DrawRect(0, h - 1, w, h)
    end
end

function PANEL:PerformLayout(w, h)
    local y = 0
    self.Title:SetPos(0, 0)
    self.Title:SetWide(w)

    y = y + self.Title:GetTall() + self:GetSpacing()

    self.ComboBox:SetPos(0, y)
    self.ComboBox:SetWide(w)

    y = y + self.ComboBox:GetTall() + self:GetSpacing()

    self.Description:SetPos(0, y)
    self.Description:SetWide(w)

    y = y + self.Description:GetTall()

    if self:GetSeperator() then
        y = y + 4
    end

    self:SetTall(y)
end

vgui.Register("Advisor.DropDownSettingOption", PANEL, "EditablePanel")