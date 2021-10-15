local PANEL = {}

function PANEL:Init()
    self.AdvisorVersion = vgui.Create("Advisor.HeaderBox", self)
    self.AdvisorVersion:Dock(TOP)
    self.AdvisorVersion:DockMargin(16, 16, 16, 16)
    self.AdvisorVersion:SetHeaderText("Addon Information")
    self.AdvisorVersion:SetBodyText("Welcome to Advisor's administration dashboard.")

    self.ButtonLayout = vgui.Create("Advisor.HorizontalLayout", self)
    self.ButtonLayout:Dock(TOP)
    self.ButtonLayout:DockMargin(16, 0, 16, 16)
    self.ButtonLayout:SetHeight(32)
    self.ButtonLayout:SetSpacing(32)
    --self.ButtonLayout:DockPadding(8, 8, 8, 0)

    local discordButton = self.ButtonLayout:Add("Advisor.Button")
    discordButton:SetText("Join Discord")
    discordButton:SetIcon(0xf0c1)
    function discordButton:DoClick()
        gui.OpenURL("https://discord.gg/gca")
    end

    local githubButton = self.ButtonLayout:Add("Advisor.Button")
    githubButton:SetText("GitHub")
    githubButton:SetIcon(0xf0c1)
    function githubButton:DoClick()
        gui.OpenURL(Advisor.RepositoryURL)
    end
end

vgui.Register("Advisor.Menu.Home", PANEL, "Advisor.Panel")