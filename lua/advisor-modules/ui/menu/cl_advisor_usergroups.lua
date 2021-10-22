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

    self.UsergroupSettings = vgui.Create("Advisor.Panel", self, "UsergroupSettings")
    self.UsergroupSettings:Dock(FILL)
    self.UsergroupSettings:SetMouseInputEnabled(true)

    function self.UsergroupSettings:OnMousePressed(key)
        local window = self:GetParent():GetParent()
        window:OnMousePressed(key)
    end

    function self.UsergroupSettings:OnMouseReleased(key)
        local window = self:GetParent():GetParent()
        window:OnMouseReleased(key)
    end

    hook.Add("Advisor.OnUsergroupsUpdated", self, self.OnUsergroupsUpdated)
    -- Populate the usergroup list.
    self:OnUsergroupsUpdated()
end

function PANEL:OnRemove()
    -- Cleanup hooks to avoid dangling references
    hook.Remove("Advisor.OnUsergroupsUpdated", self)
end

function PANEL:OnUsergroupsUpdated()
    self.Usergroups:Clear()

    for _, group in ipairs(self:GetSortedUsergroups()) do
        local panel = vgui.Create("Advisor.UsergroupOption", nil, group)
        panel:SetUsergroup(group)
        self.Usergroups:AddItem(panel)
    end
end

function PANEL:GetSortedUsergroups()
    local sorted = {}
    local usergroups = Advisor.Permissions.Usergroups
    local inheritanceSort = 
    {
        ["user"] = {}
    }

    self:GetInheritedUsergroups(usergroups, inheritanceSort["user"], "user")
    self:FlattenHierarchy(inheritanceSort, inheritanceSort["user"])

    local order = { "user", "admin", "superadmin" }
    for _, v in ipairs(order) do
        sorted[#sorted + 1] = v
        self:OrderUsergroups(sorted, inheritanceSort[v])
    end

    return table.Reverse(sorted)
end

function PANEL:GetInheritedUsergroups(usergroups, tbl, group)
    for _, curr in ipairs(usergroups) do
        if curr:GetName() == group then continue end
        if curr:GetInherits() == group then
            local name = curr:GetName()
            tbl[name] = {}
            self:GetInheritedUsergroups(usergroups, tbl[name], name)
        end
    end
end

function PANEL:FlattenHierarchy(sorted, tbl)
    for base, derived in pairs(tbl) do
        if base == "admin" or base == "superadmin" then
            sorted[base] = derived
            tbl[base] = nil
        end

        self:FlattenHierarchy(sorted, derived)
    end
end

function PANEL:OrderUsergroups(result, tbl)
    for k, v in SortedPairs(tbl, true) do
        result[#result + 1] = k
        self:OrderUsergroups(result, v)
    end
end

vgui.Register("Advisor.Menu.Usergroups", PANEL, "Advisor.Panel")