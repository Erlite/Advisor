local PANEL = {}

function PANEL:Init()
    local parent = self

    -- Replacing some GUI with ours (https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dnumslider.lua)

    -- Replace DSlider with Advisor.Slider
    self.Slider:Remove()
    self.Slider = self:Add("Advisor.Slider", self)
    self.Slider:SetLockY(0.5)
    self.Slider:Dock(FILL)
    self.Slider:SetHeight(16)
    local oldTranslate = self.Slider.TranslateValues
    function self.Slider:TranslateValues(x, y) 
        return parent:TranslateSliderValues(oldTranslate(self, x, y))
    end
    function self.Slider.Knob:OnMousePressed(mcode)
        if mcode == MOUSE_MIDDLE then
            parent:ResetToDefaultValue()
            return
        end
        parent.Slider:OnMousePressed(mcode)
    end

    -- Replace DTextEntry with Advisor.TextEntry 
    self.TextArea:Remove()
    self.TextArea = vgui.Create("Advisor.TextEntry", self)
    self.TextArea:Dock(RIGHT)
    self.TextArea:DockMargin(self.Slider:GetCornerRadius() * 2, 0, 0, 0)
    self.TextArea:SetPaintBackground(false)
    self.TextArea:SetNumeric(true)
    function self.TextArea:OnEnter() 
        -- Clamp value to min & max
        self:SetText(math.Clamp(self:GetValue(), parent:GetMin(), parent:GetMax()))

        parent:SetValue(self:GetValue())
        parent:OnValueApplied(parent:GetValue())
    end

    -- Bind OnValueApplied callback to Slider's Mouse Release
    local oldMouseRelease = self.Slider.OnMouseReleased
    function self.Slider:OnMouseReleased(keyCode)
        oldMouseRelease(self, keyCode)
        
        parent:SetValue(math.Round(parent:GetValue(), parent:GetDecimals()))
        parent:OnValueApplied(parent:GetValue())
    end

    self.Label:SetFont("Advisor:Rubik.Body")
end

function PANEL:PerformLayout(w, h)
    baseclass.Get("DNumSlider").PerformLayout(self, w, h)

    surface.SetFont(self.TextArea:GetFont())
    local textWide = surface.GetTextSize(self.TextArea:GetValue() .. self.TextArea:GetSuffix())
    self.TextArea:SetWide(math.max(45, textWide + 16))
end

function PANEL:AddNotches(...)
    for i, v in ipairs({ ... }) do
        if istable(v) then 
            self:AddNotch(unpack(v)) 
        else 
            self:AddNotch(v)
        end
    end
end

function PANEL:AddNotch(name, value)
    if not value then
        value = name
    end

    --  as the Slider doesn't have access to Min & Max, we have to compute the SlideX here
    self.Slider:AddNotch(name, (value - self:GetMin()) / (self:GetMax() - self:GetMin()))
end

function PANEL:SetNotchSnapping(bool)
    self.Slider:SetNotchSnapping(bool)
end

function PANEL:ApplySchemeSettings()
    self.Label:ApplySchemeSettings()
end

function PANEL:OnValueApplied(value)
    -- For override
end

vgui.Register("Advisor.NumSlider", PANEL, "DNumSlider")