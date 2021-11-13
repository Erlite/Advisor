local PANEL = {}

AccessorFunc(PANEL, "Selection", "Selection")

function PANEL:Init()
    self.Splitter = vgui.Create("Panel", self, "LeftSplitter")
    self.Splitter:Dock(LEFT)
    self.Splitter:SetWidth(1)

    function self.Splitter:Paint(w, h)
        surface.SetDrawColor(Color(11, 11, 11))
        surface.DrawRect(0, 0, w, h)
    end

    self.LeftPanel = vgui.Create("EditablePanel", self)
    self.LeftPanel:Dock(LEFT)
    self.LeftPanel:SetWidth(ScrW() * 0.1)

    self.Usergroups = vgui.Create("Advisor.ScrollPanel", self.LeftPanel)
    self.Usergroups:Dock(FILL)

    -- Add a panel under the usergroups
    self.ButtonPanel = vgui.Create("Advisor.VerticalLayout", self.LeftPanel)
    self.ButtonPanel:Dock(BOTTOM)
    self.ButtonPanel:DockPadding(8, 0, 8, 8)
    self.ButtonPanel:SetSpacing(8)
    self.ButtonPanel:SetHeight(80)

    function self.ButtonPanel:Paint(w, h)
        surface.SetDrawColor(Advisor.Theme.ScrollPanel.Background)
        surface.DrawRect(0, 0, w, h)
    end
    
    self.CreateButton = self.ButtonPanel:Add("Advisor.Button")
    self.CreateButton:SetText("Create New")
    self.CreateButton:SetIcon(0xf055)

    self.DeleteButton = self.ButtonPanel:Add("Advisor.Button")
    self.DeleteButton:SetText("Delete")
    self.DeleteButton:SetIcon(0xf056)
    self.DeleteButton:UpdateColors(Advisor.Theme.Button.Delete)

    self.UsergroupSettings = vgui.Create("Advisor.Panel", self, "UsergroupSettings")
    self.UsergroupSettings:Dock(FILL)
    self.UsergroupSettings:DockPadding(16, 16, 16, 16)
    self.UsergroupSettings:SetMouseInputEnabled(true)

    function self.UsergroupSettings:OnMousePressed(key)
        local window = self:GetParent():GetParent()
        window:OnMousePressed(key)
    end

    function self.UsergroupSettings:OnMouseReleased(key)
        local window = self:GetParent():GetParent()
        window:OnMouseReleased(key)
    end


    self.PartialControlHeader = vgui.Create("Advisor.HeaderBox", self.UsergroupSettings)
    self.PartialControlHeader:Dock(FILL)

    self:SetSelection(nil)

    hook.Add("Advisor.OnUsergroupsUpdated", self, self.OnUsergroupsUpdated)
    -- Populate the usergroup list.
    self:OnUsergroupsUpdated()
end

function PANEL:OnRemove()
    -- Cleanup hooks to avoid dangling references
    hook.Remove("Advisor.OnUsergroupsUpdated", self)
end

function PANEL:UpdateSelection(selection)
    if self:GetSelection() == selection then return end
    self:SetSelection(selection)
    self.Usergroups:UpdateSelection(selection)

    local group = Advisor.Permissions.GetUsergroup(selection:GetUsergroup())
    if group:GetPartialControl() then
        self.PartialControlHeader:SetHeaderAccentColor(Advisor.Theme.HeaderBox.HeaderAccentColor)
        self.PartialControlHeader:SetHeaderText("Partial Control")
        self.PartialControlHeader:SetBodyText("This usergroup may be affected by the following addon:\n\n- " .. group:GetSource())
    elseif group:GetSource() ~= Advisor.Source then
        self.PartialControlHeader:SetHeaderAccentColor(Advisor.Theme.HeaderBox.HeaderErrorAccent)
        self.PartialControlHeader:SetHeaderText("Third Party Control")
        self.PartialControlHeader:SetBodyText("This usergroup is entirely controlled by the following addon:\n\n- " .. group:GetSource())
    else
        self.PartialControlHeader:SetHeaderAccentColor(Advisor.Theme.HeaderBox.HeaderValidationAccent)
        self.PartialControlHeader:SetHeaderText("Total Control")
        self.PartialControlHeader:SetBodyText("This usergroup is entirely controlled by Advisor.")
    end

    self.DeleteButton:SetEnabled(group:GetCanDelete())
end

function PANEL:OnUsergroupsUpdated()
    self.Usergroups:Clear()

    for _, group in ipairs(self:GetSortedUsergroups()) do
        local panel = vgui.Create("Advisor.UsergroupOption", nil, group)
        panel:SetUsergroup(group)
        panel:SetScrollPanel(self)
        self.Usergroups:AddItem(panel)

        if #self.Usergroups:GetCanvas():GetChildren() == 1 then
            self:UpdateSelection(panel)
        end
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