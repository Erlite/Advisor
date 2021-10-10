Advisor = Advisor or {}
Advisor.MenuProperty = {}
Advisor.MenuProperty.__index = Advisor.MenuProperty

GetterFunc(Advisor.MenuProperty, "categories", "Categories")

function Advisor.MenuProperty.new()
    local tbl = 
    {
        categories = {},
    }

    setmetatable(tbl, Advisor.MenuProperty)
    return tbl
end

function Advisor.MenuProperty:AddOption(category, name, panel, ...)
    if not isstring(category) or #category == 0 then
        ErrorNoHaltWithStack(string.format("Cannot add a menu option with invalid category '%s'", category or "nil"))
        return 
    end 

    if not isstring(name) or #name == 0 then
        ErrorNoHaltWithStack(string.format("Cannot add a menu option with invalid name '%s'", name or "nil"))
        return 
    end 

    if not ispanel(panel) or not IsValid(panel) then
        ErrorNoHaltWithStack("Cannot add a menu option with invalid panel!")
        return 
    end 

    panel:SetName(name)

    if not self.categories[category] then 
        self.categories[category] = {}
    end

    local tbl = self.categories[category]
    tbl[#tbl + 1] = { Name = name, Panel = panel, Icon = ... and {...} or nil }

    panel:SetVisible(false)
end

setmetatable(Advisor.MenuProperty, {__call = Advisor.MenuProperty.new})