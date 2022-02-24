local PANEL = {}

function PANEL:Init()
    self:DockMargin(16, 16, 16, 16)

    local LOC = Advisor.Localization.Localize

    self.Header = vgui.Create("Advisor.HeaderBox", self)
    self.Header:Dock(FILL)
    self.Header:SetHeaderText(LOC("ui", "option_appearance"))
    self.Header:SetBodyText("")
    function self.Header.BodyBox:PerformLayout()
        local parent = self:GetParent()
        local _, top, _, bottom = parent.BodyBox:GetDockPadding()
        
        local childrenTall = 0
        for i, v in ipairs(parent.BodyBox:GetChildren()) do
            childrenTall = childrenTall + v:GetTall()
        end
        
        self:SetHeight( childrenTall + top + bottom )
    end
    self.Header.BodyBox:DockPadding(0, 16, 0, 16)
    self.Header.BodyText:Remove()

    -- Text Scale Slider
    local convarTextScale = GetConVar("advisor_text_scale")
    self.TextScaleSlider = vgui.Create("Advisor.NumSlider", self.Header.BodyBox)
    self.TextScaleSlider:Dock(TOP)
    self.TextScaleSlider:DockMargin(16, 0, 16, 0)
    self.TextScaleSlider:SetText(LOC("ui", "field_text_scale"))
    self.TextScaleSlider:SetDefaultValue(100)
    self.TextScaleSlider:SetMinMax(50, 200)
    self.TextScaleSlider:SetDecimals(0)
    self.TextScaleSlider:SetValue(convarTextScale:GetFloat() * 100)
    self.TextScaleSlider.TextArea:SetSuffix("%")

    self.TextScaleSlider:SetNotchSnapping(true)
    self.TextScaleSlider:AddNotches(50, 67, 80, 90, 100, 110, 125, 150, 175, 200)

    function self.TextScaleSlider:OnValueApplied(value)
        convarTextScale:SetFloat(value / 100)
    end
    cvars.AddChangeCallback(convarTextScale:GetName(), function(name, oldValue, newValue)
        newValue = math.Round(newValue, 2)
        if newValue == self.TextScaleSlider:GetValue() / 100 then return end -- Avoid infinite call

        self.TextScaleSlider:SetValue(newValue * 100)
        self.TextScaleSlider:OnValueApplied(self.TextScaleSlider:GetValue())
    end, "Advisor.Menu.Settings")
end

vgui.Register("Advisor.Menu.Settings", PANEL, "Advisor.Panel")