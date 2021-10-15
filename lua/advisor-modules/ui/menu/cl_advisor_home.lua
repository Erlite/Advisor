local PANEL = {}

function PANEL:Init()
    self.AdvisorVersion = vgui.Create("Advisor.HeaderBox", self)
    self.AdvisorVersion:Dock(TOP)
    self.AdvisorVersion:DockMargin(16, 16, 16, 16)
    self.AdvisorVersion:SetHeaderText("Addon Information")
    self.AdvisorVersion:SetBodyText("Checking for updates...")
    
    self.ButtonLayout = vgui.Create("Advisor.HorizontalLayout", self)
    self.ButtonLayout:Dock(TOP)
    self.ButtonLayout:DockMargin(16, 0, 16, 16)
    self.ButtonLayout:SetHeight(32)
    self.ButtonLayout:SetSpacing(32)
    --self.ButtonLayout:DockPadding(8, 8, 8, 0)

    local discordButton = self.ButtonLayout:Add("Advisor.Button")
    discordButton:SetText("Discord")
    discordButton:UpdateColors(Advisor.Theme.Button.Discord)
    discordButton:SetIcon(0xf0c1)

    function discordButton:DoClick()
        gui.OpenURL("https://discord.gg/gca")
    end

    local githubButton = self.ButtonLayout:Add("Advisor.Button")
    githubButton:SetText("GitHub")
    githubButton:SetIcon(0xf126)
    function githubButton:DoClick()
        gui.OpenURL(Advisor.RepositoryURL)
    end

    local docButton = self.ButtonLayout:Add("Advisor.Button")
    docButton:SetText("Documentation")
    docButton:SetIcon(0xf1c9)
    docButton:SetEnabled(false)

    self:UpdateVersionDisplay()
end

function PANEL:UpdateVersionDisplay()
    if Advisor.HasCheckedForUpdates then
        if Advisor.UpToDate then
            self.AdvisorVersion:SetBodyText(("This server's version of Advisor is up to date (%s)."):format(Advisor.CurrentVersion))
        else
            self.AdvisorVersion:SetHeaderAccentColor(Color(255, 90, 90))
            if Advisor.VersionCheckFailed then
                self.AdvisorVersion:SetBodyText("Failed to check for updates! Please check the console for more details.")
            else
                local str = string.format("This server's version of Advisor is not up to date! The latest version is '%s', and the server is running version '%s'.",
                    Advisor.LatestVersion, Advisor.CurrentVersion)
                self.AdvisorVersion:SetBodyText(str)
            end
        end
    else
        local panel = self
        hook.Add("Advisor.OnVersionCheck", "Advisor.UpdateHomePanel", function()
            if IsValid(panel) then
                panel:UpdateVersionDisplay()
            end
        end)

        self.AdvisorVersion:SetBodyText("Checking for updates...")
    end
end

vgui.Register("Advisor.Menu.Home", PANEL, "Advisor.Panel")