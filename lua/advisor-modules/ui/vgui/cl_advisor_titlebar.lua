local PANEL = {}

GetterFunc(PANEL, "CornerRadius", "CornerRadius")

function PANEL:Init()
    self.Title = ""
    self.Icon = nil
    self.CornerRadius = 8

    self:SetHeight(32)
    self:Dock(FILL)
    self:DockPadding(8, 0, 0, 0)

    self.TitleLabel = vgui.Create("Advisor.HeaderLabel", self)
    self.CloseButton = vgui.Create("Advisor.CloseButton", self)
    self.CloseButton:Dock(RIGHT)
    self.CloseButton:SetCornerRadius(self.CornerRadius)

    function self.CloseButton:DoClick()
        local grandparent = self:GetParent() and self:GetParent():GetParent() or nil
        if IsValid(grandparent) then
            if grandparent.Close then 
                grandparent:Close()
            else
                grandparent:Remove()
            end
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