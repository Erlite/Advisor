Advisor = Advisor or {}
Advisor.Permission = {}
Advisor.Permission.__index = Advisor.Permission

function Advisor.Permission.new()
    local tbl = 
    {
        name = "", 
        value = 0,
    }

    setmetatable(tbl, Advisor.Permission)
    return tbl
end

function Advisor.Permission:GetReplicatedProperties(rt)
    rt:AddString("name")
    rt:AddBit("value")
end

setmetatable(Advisor.Permission, {__call = Advisor.Permission.new})
Replicate.SetupMetaTable(Advisor.Permission, "Advisor.Permission")