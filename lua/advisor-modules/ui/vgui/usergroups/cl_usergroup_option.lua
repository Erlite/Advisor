local PANEL = {}

GetterFunc(PANEL, "usergroup", "Usergroup")

function PANEL:Init()
    self:SetIcon()

    hook.Add("Advisor.OnUsergroupUpdated", self, self.UpdateUsergroup)
end

function PANEL:SetUsergroup(name)
    if not Advisor.Permissions.UsergroupMap[name] then
        ErrorNoHaltWithStack("Cannot bind to " .. name .. ": unknown usergroup.")
        return
    end

    self.usergroup = name
    self:UpdateUsergroup(name)
end

function PANEL:UpdateUsergroup(name)
    if self:GetUsergroup() ~= name then return end

    local group = Advisor.Permissions.UsergroupMap[name]
    if not group then
        self:Remove()
    end

    self:SetOptionName(group:GetDisplayName())
    self:SetOptionColor(group:GetColor())
end

vgui.Register("Advisor.UsergroupOption", PANEL, "Advisor.ScrollPanelOption")