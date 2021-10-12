local PANEL = {}

function PANEL:Init()
    self.ButtonLayout = vgui.Create("Advisor.HorizontalLayout", self)
    self.ButtonLayout:Dock(TOP)
    self.ButtonLayout:SetHeight(32)
    self.ButtonLayout:SetSpacing(8)
    --self.ButtonLayout:DockPadding(8, 8, 8, 0)

    for i = 1, 10 do
        local button = self.ButtonLayout:Add("Advisor.Button")
        button:SetText("Button " .. tostring(i))

        function button:DoClick()
            print("X: " .. self:GetWide())
        end
    end
end

vgui.Register("Advisor.Menu.Home", PANEL, "Advisor.Panel")