local PANEL = {}

AccessorFunc(PANEL, "CornerRadius", "CornerRadius", FORCE_NUMBER)
AccessorFunc(PANEL, "SliderHeight", "SliderHeight", FORCE_NUMBER)

AccessorFunc(PANEL, "NotchSnapping", "NotchSnapping", FORCE_BOOL)
AccessorFunc(PANEL, "NotchWidth", "NotchWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "NotchHeight", "NotchHeight", FORCE_NUMBER)

AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor", FORCE_COLOR)
AccessorFunc(PANEL, "TextColor", "TextColor", FORCE_COLOR)
AccessorFunc(PANEL, "SelectedAccentColor", "SelectedAccentColor", FORCE_COLOR)
AccessorFunc(PANEL, "SelectedTextColor", "SelectedTextColor", FORCE_COLOR)

AccessorFunc(PANEL, "KnobWidth", "KnobWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "KnobColor", "KnobColor", FORCE_COLOR)

AccessorFunc(PANEL, "Font", "Font", FORCE_STRING)

function PANEL:Init()
    self.notches = {}
    
    local parent = self

    -- Paint knob
    self.Knob:SetCursor("sizewe")
    function self.Knob:Paint(w, h)
        draw.RoundedBox(parent:GetCornerRadius(), 0, 0, w, h, parent:GetKnobColor())
    end

    -- Setup default values
    self:SetCornerRadius(Advisor.Theme.Slider.CornerRadius)
    self:SetSliderHeight(Advisor.Theme.Slider.SliderHeight)

    self:SetBackgroundColor(Advisor.Theme.Slider.BackgroundColor)
    self:SetTextColor(Advisor.Theme.Slider.TextColor)
    self:SetSelectedAccentColor(Advisor.Theme.Slider.SelectedAccentColor)
    self:SetSelectedTextColor(Advisor.Theme.Slider.SelectedTextColor)

    self:SetNotchSnapping(false)
    self:SetNotchColor(Advisor.Theme.Slider.NotchColor)
    self:SetNotchWidth(Advisor.Theme.Slider.NotchWidth)
    self:SetNotchHeight(Advisor.Theme.Slider.NotchHeight)

    self:SetKnobWidth(Advisor.Theme.Slider.KnobWidth)
    self:SetKnobColor(Advisor.Theme.Slider.KnobColor)

    self:SetFont("Advisor:Rubik.StaticSmall")
end

function PANEL:SetKnobWidth(width)
    self.KnobWidth = width
    self:InvalidateLayout()
end

function PANEL:PerformLayout(w, h)
    baseclass.Get("DSlider").PerformLayout(self, w, h)

    self.Knob:SetTall(self:GetNotchHeight())
    self.Knob:SetWide(self:GetKnobWidth())
end

function PANEL:AddNotch(name, slideX)
    self.notches[#self.notches + 1] = { Name = name, SlideX = slideX }
end

function PANEL:TranslateValues(x, y)
    if self:GetNotchSnapping() then
        local nearNotchX, nearDist = 0, math.huge
        for i, v in ipairs(self.notches) do
            local dist = math.abs(v.SlideX - x)
            if dist <= nearDist then
                nearNotchX = v.SlideX
                nearDist = dist
            end
        end

        return nearNotchX, y
    end

    return x, y
end

function PANEL:Paint(w, h)
    DisableClipping(true)

    -- Draw notches
    local notchWidth, notchHeight = self:GetNotchWidth(), self:GetNotchHeight()
    local notchY = h / 2 - notchHeight / 2
    for i, v in ipairs(self.notches) do
        --  Notch
        surface.SetDrawColor(self:GetNotchColor())
        surface.DrawRect(w * v.SlideX - notchWidth / 2, notchY, notchWidth, notchHeight)

        --  Text
        local textColor = v.SlideX == self:GetSlideX() and self:GetSelectedTextColor() or self:GetTextColor()
        draw.SimpleText(v.Name, self:GetFont(), w * v.SlideX, notchY, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    end

    -- Draw slider
    local radius = self:GetCornerRadius()
    local tall = self:GetSliderHeight()
    local knobWidth = self:GetKnobWidth()
    draw.RoundedBox(radius, -knobWidth / 2, h / 2 - tall / 2, w + knobWidth, tall, self:GetBackgroundColor())
    draw.RoundedBox(radius, -knobWidth / 2, h / 2 - tall / 2, w * self:GetSlideX() + knobWidth, tall, self:GetSelectedAccentColor())
    
    DisableClipping(false)
end

vgui.Register("Advisor.Slider", PANEL, "DSlider")