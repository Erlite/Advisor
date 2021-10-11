local PANEL = {}

function PANEL:Init()
    local button = vgui.Create("Advisor.Button", self)
    button:DockMargin(16, 16, 16, 16)
    button:Dock(TOP)

    function button:DoClick()
        chat.AddText("Hello, World!")
    end
end

vgui.Register("Advisor.Menu.Home", PANEL, "Advisor.Panel")