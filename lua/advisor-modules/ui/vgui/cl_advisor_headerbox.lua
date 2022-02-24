local PANEL = {}

AccessorFunc(PANEL, "HeaderAccentColor", "HeaderAccentColor")
AccessorFunc(PANEL, "HeaderBackgroundColor", "HeaderBackgroundColor")
AccessorFunc(PANEL, "HeaderCornerRadius", "HeaderCornerRadius", FORCE_NUMBER)
AccessorFunc(PANEL, "BodyBackgroundColor", "BodyBackgroundColor")
AccessorFunc(PANEL, "BodyCornerRadius", "BodyCornerRadius", FORCE_NUMBER)

-- TODO: Make responsive.

function PANEL:Init()

    self:SetHeaderCornerRadius(Advisor.Theme.HeaderBox.HeaderCornerRadius)
    self:SetHeaderAccentColor(Advisor.Theme.HeaderBox.HeaderAccentColor)
    self:SetHeaderBackgroundColor(Advisor.Theme.HeaderBox.HeaderBackgroundColor)
    self:SetBodyBackgroundColor(Advisor.Theme.HeaderBox.BodyBackgroundColor)
    self:SetBodyCornerRadius(Advisor.Theme.HeaderBox.BodyCornerRadius)

    self.HeaderBox = vgui.Create("EditablePanel", self)
    self.HeaderBox:SetHeight(48)
    self.HeaderBox:Dock(TOP)
    self.HeaderBox:DockPadding(16, 4, 0, 0)
    self.HeaderBox:SetContentAlignment(4)

    function self.HeaderBox:Paint(w, h)
        local parent = self:GetParent()
        local accent = parent:GetHeaderAccentColor()

        if accent then 
            draw.RoundedBoxEx(parent:GetHeaderCornerRadius(), 0, 0, w, h, parent:GetHeaderAccentColor(), true, true, false, false)

            surface.SetDrawColor(parent:GetHeaderBackgroundColor())
            surface.DrawRect(0, 4, w, h)
        else 
            draw.RoundedBoxEx(parent:GetHeaderCornerRadius(), 0, 0, w, h, parent:GetHeaderBackgroundColor(), true, true, false, false)
        end
    end

    self.HeaderLabel = vgui.Create("DLabel", self.HeaderBox)
    self.HeaderLabel:Dock(FILL)
    self.HeaderLabel:SetFont("Advisor:Rubik.Header")
    self.HeaderLabel:SetText("Header")
    self.HeaderLabel:SizeToContents()
    self.HeaderLabel:SetTextColor(Advisor.Theme.HeaderBox.HeaderTextColor)

    self.BodyBox = vgui.Create("EditablePanel", self)
    self.BodyBox:Dock(TOP)
    self.BodyBox:SetContentAlignment(4)

    self.BodyText = vgui.Create("DLabel", self.BodyBox)
    self.BodyText:Dock(TOP)
    self.BodyText:DockMargin(16, 16, 16, 16)
    self.BodyText:SetFont("Advisor:Rubik.Body")
    self.BodyText:SetTextColor(Advisor.Theme.HeaderBox.BodyTextColor)

    function self.BodyBox:Paint(w, h)
        local parent = self:GetParent()
        draw.RoundedBoxEx(parent:GetBodyCornerRadius(), 0, 0, w, h, parent:GetBodyBackgroundColor(), false, false, true, true)
    end

    function self.BodyBox:PerformLayout(w, h)
        local parent = self:GetParent()
        local _, top, _, bottom = parent.BodyText:GetDockMargin()
        self:SetHeight(parent.BodyText:GetTall() + top + bottom)
    end

    self:SetBodyText("Hello, World!")
end

function PANEL:GetHeaderText()
    return self.HeaderLabel:GetText()
end

function PANEL:SetHeaderText(text)
    self.HeaderLabel:SetText(text)
    self.HeaderLabel:SizeToContents()
end

function PANEL:GetBodyText()
    return self.BodyText:GetText()
end

function PANEL:SetBodyText(text)
    self.BodyText:SetText(text)

    -- Update Label to his Content (for unknown reasons surface.GetTextSize is more reliable in the tall)
    surface.SetFont(self.BodyText:GetFont())
    self.BodyText:SetSize(surface.GetTextSize(text))
end

function PANEL:PerformLayout(w, h)
    if IsValid( self.BodyText ) then
        self.BodyText:SizeToContents()
    end
    self:SizeToChildren(false, true)
end

vgui.Register("Advisor.HeaderBox", PANEL, "EditablePanel")