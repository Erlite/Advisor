Advisor = Advisor or {}
Advisor.CommandArg = {}
Advisor.CommandArg.__index = Advisor.CommandArg

function Advisor.CommandArg.new()
    
    local tbl = 
    {
        name = "",
        description = ""
        type = nil,
    }

    setmetatable(tbl, Advisor.CommandArg)
    return tbl
end

AccessorFunc(Advisor.CommandArg, "name", "Name")
AccessorFunc(Advisor.CommandArg, "description", "Description")

function Advisor.CommandArg:SetType(t)
    local found = false
    for _, v in pairs(Advisor.ArgType) do
        if v == t then 
            found = true
            break
        end
    end

    if not found then
        ErrorNoHaltWithStack(string.format("Cannot set argument type to unknown type %s", tostring(t) or "nil"))
        return
    end

    self.type = t
end

setmetatable(Advisor.CommandArg, {__call = Advisor.CommandArg.new})