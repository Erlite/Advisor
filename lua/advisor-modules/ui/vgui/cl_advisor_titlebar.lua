local PANEL = {}

GetterFunc(PANEL, "CornerRadius", "CornerRadius")

function PANEL:Init()
    self.Title = ""
    self.Icon = nil
    self.CornerRadius = Advisor.Theme.TitleBar.CornerRadius

    self:SetHeight(40)
    self:Dock(FILL)
    self:DockPadding(8, 0, 0, 0)

    self.TitleLabel = vgui.Create("Advisor.HeaderLabel", self)
    self.CloseButton = vgui.Create("Advisor.CloseButton", self)
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:SetCornerRadius(self.CornerRadius)

    function self.CloseButton:DoClick()
        local grandparent = self:GetParent() and self:GetParent():GetParent() or nil
        if IsValid(grandparent) then
            grandparent:SlideUp(0.5)

            timer.Simple(0.5, function()
                if not IsValid(grandparent) then return end
                if grandparent.Close then 
                    grandparent:Close()
                else
                    grandparent:Remove()
                end
            end)
        end
    end

    self.MaximizeButton = vgui.Create("Advisor.MaximizeButton", self)
    self.MaximizeButton:Dock(RIGHT)

    function self.MaximizeButton:DoClick()
        local grandparent = self:GetParent() and self:GetParent():GetParent() or nil
        if IsValid(grandparent) then
            grandparent:MoveTo(0, 0, 0.5, 0, 0.1)
            grandparent:SizeTo(ScrW(), ScrH(), 0.5, 0, 0.1)
        end
    end

    self.MinimizeButton = vgui.Create("Advisor.MinimizeButton", self)
    self.MinimizeButton:Dock(RIGHT)

    function self.MinimizeButton:DoClick()
        local grandparent = self:GetParent() and self:GetParent():GetParent() or nil
        if IsValid(grandparent) then
            local minW = grandparent:GetMinWidth()
            local minH = grandparent:GetMinHeight()

            grandparent:MoveTo(ScrW() / 2 - minW / 2, ScrH() / 2 - minH / 2, 0.5, 0, 0.1)
            grandparent:SizeTo(minW, minH, 0.5, 0, 0.1)
        end
    end
end

function PANEL:GetTitle()
    return self.TitleLabel:GetText()
end

function PANEL:SetTitle(txt)
    self.TitleLabel:SetText(txt)
    self.TitleLabel:SizeToContentsX()
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(self.CornerRadius, 0, 0, w, h, Advisor.Theme.TitleBar.Background, true, true, false, false)
end

function PANEL:SetCornerRadius(num)
    self.CornerRadius = math.max(num, 0)
end

vgui.Register("Advisor.TitleBar", PANEL, "EditablePanel")