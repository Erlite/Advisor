Advisor = Advisor or {}
Advisor.Role = {}
Advisor.Role.__index = Advisor.Role

function Advisor.Role.new()
    local tbl =
    {
        id = 0,
        name = "",
        description = "",
        color = 0xFFFFFF,
        hoisted = 0,
        weight = 0,
    }

    setmetatable(tbl, Advisor.Role)
    return tbl
end

AccessorFunc(Advisor.Role, "id", "ID", FORCE_NUMBER)
AccessorFunc(Advisor.Role, "name", "Name", FORCE_STRING)
AccessorFunc(Advisor.Role, "description", "Description", FORCE_STRING)
AccessorFunc(Advisor.Role, "weight", "Weight", FORCE_NUMBER)

function Advisor.Role:GetReplicatedProperties(rt)
    rt:AddUInt("id", 32)
    rt:AddString("name")
    rt:AddString("description")
    rt:AddUInt("color", 24)
    rt:AddBit("hoisted")
    rt:AddUInt("weight", 8)
end

-- Convert the 4-byte integer representation of the color to a Color table
function Advisor.Role:GetColor()
    local R = bit.band(bit.rshift(self.color, 16), 0xFF)
    local G = bit.band(bit.rshift(self.color, 8), 0xFF)
    local B = bit.band(self.color, 0xFF)

    return Color(R, G, B)
end

function Advisor.Role:SetColor(color)
    if not color or not IsColor(color) then
        error("Cannot set role color to invalid color: " .. color or "nil")
    end

    local c = 0
    c = bit.bor(c, bit.lshift(color.R, 16))
    c = bit.bor(c, bit.lshift(color.G, 8))
    c = bit.bor(c, color.B)

    self.color = c
end

function Advisor.Role:IsHoisted()
    return self.hoisted and self.hoisted == 1
end

function Advisor.Role:SetHoisted(value)
    self.hoisted = (isbool(value) and value) and 1 or 0 
end   

setmetatable(Advisor.Role, {__call = Advisor.Role.new})
Replicate.SetupMetaTable(Advisor.Role, "Advisor.Role")