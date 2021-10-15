local PANEL = {}

function PANEL:Init()
    local title = "Advisor"
    
    if #Advisor.Theme.FlavorText ~= 0 then
        title = title .. " - " .. Advisor.Theme.FlavorText[math.random(#Advisor.Theme.FlavorText)]
    end

    self:SetTitle(title)
    self:SetSize(ScrW() * 0.6, ScrH() * 0.6)
    self:SetMinWidth(ScrW() * 0.6)
    self:SetMinHeight(ScrH() * 0.6)
    self:SetScreenLock(true) 
    self:Center()
    self:SetDeleteOnClose(false)
    self:SetSizable(true)

    self.Categories = vgui.Create("Advisor.ScrollPanel", self)
    self.Categories:Dock(LEFT)
    self.Categories:SetWidth(ScrW() * 0.1)
end

function PANEL:PopulateOptions(mp)
    local cats = mp:GetCategories()

    for _, cat in ipairs(cats) do
        self.Categories:AddCategory(cat.Name)

        for _, option in ipairs(cat.Children) do
            self.Categories:AddOption(option.Name, option.Panel, option.Icon and unpack(option.Icon) or nil)
        end
    end
end

vgui.Register("Advisor.Menu", PANEL, "Advisor.Window")