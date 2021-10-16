local PANEL = {}

function PANEL:Init()
    -- self.Header = vgui.Create("Advisor.HeaderBox", self)
    -- self.Header:Dock(TOP)
    -- self.Header:DockMargin(16, 16, 16, 16)
    -- self.Header:SetHeaderText("Usergroups Dashboard")
    -- self.Header:SetBodyText("Welcome to the usergroups dashboard.")

    self.Splitter = vgui.Create("Panel", self)
    self.Splitter:Dock(LEFT)
    self.Splitter:SetWidth(1)

    function self.Splitter:Paint(w, h)
        surface.SetDrawColor(Color(11, 11, 11))
        surface.DrawRect(0, 0, w, h)
    end

    self.Usergroups = vgui.Create("Advisor.ScrollPanel", self)
    self.Usergroups:Dock(LEFT)
    self.Usergroups:SetWidth(ScrW() * 0.1)
end

vgui.Register("Advisor.Menu.Usergroups", PANEL, "Advisor.Panel")