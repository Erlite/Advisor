Advisor = Advisor or {}
Advisor.CommandArg = {}
Advisor.CommandArg.__index = Advisor.CommandArg

function Advisor.CommandArg.new()
    local tbl = 
    {
        name = "",
        description = ""
        type = nil,
        optional = false,
        default = nil,
    }

    setmetatable(tbl, Advisor.CommandArg)
    return tbl
end

AccessorFunc(Advisor.CommandArg, "name", "Name")
AccessorFunc(Advisor.CommandArg, "description", "Description")
AccessorFunc(Advisor.CommandArg, "optional", "Optional")
AccessorFunc(Advisor.CommandArg, "default", "Default")
GetterFunc(Advisor.CommandArg, "type", "Type")

function Advisor.CommandArg:SetType(t)
    if not Advisor.CommandHandler.HasParser(t) then
        ErrorNoHaltWithStack(string.format("Cannot set argument type to unknown type %s", tostring(t) or "nil"))
        return
    end

    self.type = t
end

setmetatable(Advisor.CommandArg, {__call = Advisor.CommandArg.new})