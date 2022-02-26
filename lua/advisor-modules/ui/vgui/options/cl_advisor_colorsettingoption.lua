local PANEL = {}

AccessorFunc(PANEL, "Spacing", "Spacing", FORCE_NUMBER)
AccessorFunc(PANEL, "Seperator", "Seperator", FORCE_BOOL)

local defaultPalette =
{
    Color(26, 188, 156), Color(17, 128, 106), Color(46, 204, 113), Color(31, 139, 76),
    Color(52, 152, 219), Color(32, 102, 148), Color(155, 89, 182), Color(113, 54, 138),
    Color(233, 30, 99), Color(123, 36, 77), Color(241, 196, 15), Color(194, 124, 14),
    Color(230, 126, 34), Color(168, 67, 0), Color(231, 76, 60), Color(153, 45, 34),
    Color(149, 165, 166), Color(151, 156, 159), Color(96, 125, 139), Color(84, 110, 122),
}

function PANEL:Init()

    self.Title = vgui.Create("DLabel", self)
    self.Title:Dock(NODOCK)
    self.Title:SetFont("Advisor:Rubik.OptionTitle")
    self.Title:SetText("Name")
    self.Title:SizeToContents()

    self.DefaultColorButton = vgui.Create("Advisor.ColorButton", self)
    self.DefaultColorButton:Dock(NODOCK)
    self.DefaultColorButton:SetTooltip(false)
    self.DefaultColorButton:SetAdvisorTooltip("Default Color")
    self.DefaultColorButton:SetAdvisorTooltipDirection(BOTTOM)

    self.ColorPickerButton = vgui.Create("Advisor.ColorButton", self)
    self.ColorPickerButton:Dock(NODOCK)
    self.ColorPickerButton:SetEmpty(true)
    self.ColorPickerButton:SetTooltip(false)
    self.ColorPickerButton:SetAdvisorTooltip("Color Picker")
    self.ColorPickerButton:SetAdvisorTooltipDirection(BOTTOM)


    self:SetColor(Color(255, 255, 255, 255))

    local option = self

    function self.DefaultColorButton:DoClick()
        option.ColorPickerButton:SetEmpty(true)
        option:SetColor(self:GetColor())
    end

    function self.ColorPickerButton:DoClick()
        if IsValid(self.Picker) then
            return
        end

        self.Picker = vgui.Create("Advisor.ColorPicker")

        if not self:GetEmpty() then
            self.Picker:SetColor(self:GetColor())
        end
        
        local cPicker = self
        function self.Picker:OnRemove()
            if cPicker then
                cPicker.Picker = nil
            end
        end

        function self.Picker:OnColorChanged(color)
            cPicker:SetColor(color)
        end

        local cursorX, cursorY = input.GetCursorPos()
        if cursorY - self.Picker:GetWide() > 0 then
            cursorY = cursorY - self.Picker:GetWide()
        end

        self.Picker:SetPos(cursorX, cursorY)
        self.Picker:MakePopup()
        self.Picker:RequestFocus()
    end

    self.Palette = {}
    for i = 1, #defaultPalette do
        local button = vgui.Create("Advisor.ColorButton", self)
        button:SetColor(defaultPalette[i])
        button:SetTooltip(false)

        local option = self
        function button:DoClick()
            option.ColorPickerButton:SetColor(self:GetColor(), true)
        end
        self.Palette[i] = button
    end

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

function PANEL:SetDefaultColor(color)
    if iscolor(color) then
       self.DefaultColorButton:SetColor(color)
    end
end

function PANEL:GetColor()
    return self.color or Color(255, 255, 255, 255)
end

function PANEL:SetColor(value)
    if not IsColor(value) then
        error("Advisor.ColorSettingOption expecting Color for SetColor()")
        return
    end

    value.a = 255
    self.color = value
    if value == Color(255, 255, 255, 255) then
        self.ColorPickerButton:SetEmpty(true)
    else
        self.ColorPickerButton:SetColor(value)
    end
end

function PANEL:Paint(w, h)
    if self:GetSeperator() then
        surface.SetDrawColor(Advisor.Theme.SettingOption.SeparatorColor)
        surface.DrawRect(0, h - 1, w, h)
    end
end

-- TODO: Make responsive
function PANEL:PerformLayout(w, h)
    local y = 0
    self.Title:SetPos(0, 0)
    self.Title:SetWide(w)

    y = y + self.Title:GetTall() + self:GetSpacing()

    self.DefaultColorButton:SetPos(0, y)
    self.DefaultColorButton:SetSize(66, 50)

    self.ColorPickerButton:SetPos(self.DefaultColorButton:GetWide() + 10, y)
    self.ColorPickerButton:SetSize(66, 50)

    -- Set the position of all the default palette buttons.
    local xOffset = self.ColorPickerButton:GetX() + self.ColorPickerButton:GetWide() + 10

    for i = 1, #self.Palette do
        if i ~= 1 and i % 2 ~= 0 then
            xOffset = xOffset + 30
        end
        local button = self.Palette[i]
        button:SetSize(20, 20)
        button:SetPos(xOffset, i % 2 == 0 and y + 30 or y)
    end

    y = y + self.DefaultColorButton:GetTall() + self:GetSpacing()

    self.Description:SetPos(0, y)
    self.Description:SetWide(w)

    y = y + self.Description:GetTall()

    if self:GetSeperator() then
        y = y + 4
    end

    self:SetTall(y)
end

vgui.Register("Advisor.ColorSettingOption", PANEL, "EditablePanel")