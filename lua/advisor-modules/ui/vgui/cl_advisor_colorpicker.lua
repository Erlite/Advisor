local PANEL = {}

function PANEL:Init()
    self:SetSize(242, 244)
    self:DockPadding(10, 10, 10, 10)

    self.ColorCube = vgui.Create("DColorCube", self)
    self.ColorCube:Dock(NODOCK)
    self.ColorCube:SetColor(Color(255, 255, 255, 255))

    self.RGBPicker = vgui.Create("DRGBPicker", self)
    self.RGBPicker:Dock(NODOCK)

    self.HEXEntry = vgui.Create("Advisor.TextEntry", self)
    self.HEXEntry:Dock(NODOCK)
    self.HEXEntry:SetText("##FFFFFF")

    local picker = self
    function self.RGBPicker:OnChange(color)
        picker.ColorCube:SetColor(color)
        picker.HEXEntry:SetText(picker:RGBToHex(color.r, color.g, color.b))
        picker:OnColorChanged(color)
    end

    function self.ColorCube:OnUserChanged(color)
        picker.HEXEntry:SetText(picker:RGBToHex(color.r, color.g, color.b))
        picker:OnColorChanged(color)
    end

    function self.HEXEntry:OnEnter(value)
        value = value:Trim()

        local currentColor = picker.ColorCube:GetRGB()

        -- Make sure we have a valid HEX color in length.
        if #value ~= 6 and #value ~= 7 then
            self:SetText(picker:RGBToHex(currentColor.r, currentColor.g, currentColor.b))
            return
        end

        -- Make sure it's a valid hex string as well.
        local r, g, b = picker:HexToRGB(value)
        if not isnumber(r) or not isnumber(g) or not isnumber(b) then
            self:SetText(picker:RGBToHex(currentColor.r, currentColor.g, currentColor.b))
            return
        end

        r = math.Clamp(r, 0, 255)
        g = math.Clamp(g, 0, 255)
        b = math.Clamp(b, 0, 255)

        -- Update the color cube, and update the text.
        local newColor = Color(r, g, b, 255)
        picker.ColorCube:SetColor(newColor)
        picker:OnColorChanged(newColor)
        self:SetText(picker:RGBToHex(r, g, b))
    end

    Advisor.UI:GetTooltip():AddTooltipBlocker()
    hook.Add("VGUIMousePressed", self, self.HandleVGUIMousePressed)
end

function PANEL:HandleVGUIMousePressed(panel, keyCode)
    local posX, posY = input.GetCursorPos()
    local x, y, w, h = self:GetBounds()

    if posX < x or posX > x + w or posY < y or posY > y + h then
        Advisor.UI:GetTooltip():RemoveTooltipBlocker()
        self:Remove()
    end
end

function PANEL:SetColor(value)
    -- No transparency in the picker.
    value.a = 255
    self.ColorCube:SetColor(value)
    local hex = self:RGBToHex(value.r, value.g, value.b)
    self.HEXEntry:SetText(hex)
end

function PANEL:OnColorChanged(color)
end

function PANEL:PerformLayout(w, h)
    self.ColorCube:SetPos(10, 10)
    self.ColorCube:SetSize(180, 180)

    self.RGBPicker:SetPos(200, 10)
    self.RGBPicker:SetSize(32, 180)
    -- self.RGBPicker:SetX(20 + self.ColorCube:GetWide())

    self.HEXEntry:SetPos(10, 200)
    self.HEXEntry:SetSize(222, 32)
end

function PANEL:Paint(w, h)
    local cornerRadius = Advisor.Theme.ColorPicker.CornerRadius
    draw.RoundedBox(cornerRadius, 0, 0, w, h, Advisor.Theme.ColorPicker.OutlineColor)
    draw.RoundedBox(cornerRadius, 1, 1, w - 2, h - 2, Advisor.Theme.ColorPicker.BackgroundColor)
end

-- TODO: Move to Advisor.Utils
function PANEL:RGBToHex(r, g, b)
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return "##" .. string.format("%06x", rgb):upper()
end

function PANEL:HexToRGB(hex)
    hex = hex:gsub("#","")
    return tonumber("0x" .. hex:sub(1,2)), tonumber("0x" .. hex:sub(3,4)), tonumber("0x" .. hex:sub(5,6))
end

vgui.Register("Advisor.ColorPicker", PANEL, "EditablePanel")