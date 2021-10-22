local PANEL = {}

GetterFunc(PANEL, "usergroup", "Usergroup")

function PANEL:Init()
    self:SetIcon(utf8.char(0xf007))
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

function PANEL:Paint(w, h)
    local base = vgui.GetControlTable(self.Base)
    base.Paint(self, w, h)
    
    surface.SetDrawColor(Color(75,75,75))
    surface.DrawLine(0, h - 1, w, h - 1)
end

vgui.Register("Advisor.UsergroupOption", PANEL, "Advisor.ScrollPanelOption")