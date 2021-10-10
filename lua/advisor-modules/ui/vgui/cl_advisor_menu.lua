local PANEL = {}

function PANEL:Init()
    local title = "Advisor"
    
    if #Advisor.Theme.FlavorText ~= 0 then
        title = title .. " - " .. Advisor.Theme.FlavorText[math.random(#Advisor.Theme.FlavorText)]
    end

    self:SetTitle(title)
    self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self:SetMinWidth(ScrW() * 0.5)
    self:SetMinHeight(ScrH() * 0.5)
    self:SetScreenLock(true) 
    self:Center()
    self:SetDeleteOnClose(true)
    self:SetSizable(true)

    self.Categories = vgui.Create("Advisor.ScrollPanel", self)
    self.Categories:Dock(LEFT)
    self.Categories:SetWidth(ScrW() * 0.1)
end

function PANEL:PopulateOptions(mp)
    local cats = mp:GetCategories()

    for cat, options in pairs(cats) do
        self.Categories:AddCategory(cat)

        for _, option in ipairs(options) do
            self.Categories:AddOption(option.Name, option.Panel, option.Icon and unpack(option.Icon) or nil)
        end
    end
end

vgui.Register("Advisor.Menu", PANEL, "Advisor.Window")