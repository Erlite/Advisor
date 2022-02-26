local PANEL = {}

function PANEL:Init()
    self:SetTitle("Advisor")
    self:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    self:SetMinWidth(ScrW() * 0.6)
    self:SetMinHeight(ScrH() * 0.6)
    self:SetScreenLock(true) 
    self:Center()
    self:SetDeleteOnClose(false)
    self:SetSizable(true)

    self.Categories = vgui.Create("Advisor.MenuScrollPanel", self)
    self.Categories:Dock(LEFT)
    self.Categories:SetWidth(ScrW() * 0.1)

    local menuWindow = self
    function self.Categories:OnSelectionUpdated(selection)
        local body = selection:GetBodyPanel()
        function body:OnMousePressed(key)
            menuWindow:OnMousePressed(key)
        end
    
        function body:OnMouseReleased(key)
            menuWindow:OnMouseReleased(key)
        end
    end
end

function PANEL:PopulateOptions(mp)
    local cats = mp:GetCategories()

    for _, cat in ipairs(cats) do
        self.Categories:AddCategory(cat.Name)

        for _, option in ipairs(cat.Children) do
            self.Categories:AddOption(option.Name, option.Panel, option.Icon, option.IconFont)
        end
    end
end

function PANEL:GenerateFlavorText()
    local title = string.Split(self:GetTitle(), "-")[1] -- Retrieve the title without the flavor text
    title = string.TrimRight(title) -- Remove right spaces
    
    if #Advisor.Theme.FlavorText ~= 0 then
        title = title .. " - " .. Advisor.Theme.FlavorText[math.random(#Advisor.Theme.FlavorText)]
    end

    self:SetTitle(title)
end

function PANEL:OnOpen()
    self:GenerateFlavorText()

    self:SlideDown(0.3)
end

vgui.Register("Advisor.Menu", PANEL, "Advisor.Window")