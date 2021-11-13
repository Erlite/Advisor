Replicate = Replicate or {}
Replicate.Funcs = Replicate.Funcs or {}
Replicate.Templates = Replicate.Templates or {}

function Replicate.SetupMetaTable(tbl, name)
    if not tbl or not istable(tbl) then
        error("Cannot setup a nil or invalid table.")
    end

    if not name or not isstring(name) or #name == 0 then
        error("You must provide a friendly name for the table!")
    end

    if not tbl.GetReplicatedProperties then
        error("Table is missing the GetReplicatedProperties() function.")
    end

    local template = ReplicationTemplate()
    tbl:GetReplicatedProperties(template)
    template:SetName(name)

    if template:IsEmpty() then
        MsgC(Color(255, 196, 0), string.format("Metatable '%s' has no replicated properties!", template:GetName()), "\n")
        return
    end

    template:AssertValid()

    Replicate.Templates[tbl] = template
end

function Replicate.WriteTable(tbl)
    -- Nil tables can just be written by WriteTable()
    if not tbl then
        net.WriteTable(tbl)
        return
    end

    -- Can't write anything other than a table.
    if tbl and not istable(tbl) then
        error("Expected to write a table, got: " .. type(tbl))
    end

    -- If it's nil, write TYPE_NIL.
    -- The reason I don't write a bit, is that this will also work in case the receiving end uses net.ReadTable() for whatever reason.
    if not tbl then 
        net.WriteType(TYPE_NIL)
    end    

    -- No metatable, use WriteTable()
    local meta = getmetatable(tbl)
    if not meta then
        net.WriteTable(tbl)
        return
    end

    -- Unregistered metatables get the WriteTable() treatment.
    if not Replicate.Templates[meta] then
        net.WriteTable(tbl)
        return
    end

    net.WriteType(TYPE_TABLE)

    local template = Replicate.Templates[meta]

    local replicated_props = {}
    -- Write every registered property.
    for index, prop in ipairs(template:GetProperties()) do
        Replicate.WriteProperty(tbl, template, replicated_props, index, prop)
    end

end

--[[
    Write a property to the net library.
    @param tbl The table that contains the property to write.
    @param template The replication template that holds the property.
    @param replicated_props An inversed table containing a list of properties that were replicated as keys.
    @param index The index of the property.
    @param prop The property to write.
--]]
function Replicate.WriteProperty(tbl, template, replicated_props, index, prop)
    local depends_on = prop:GetDependsOn()

    -- This property depends on another. Let's check that the other was replicated.
    if depends_on then
        local _, dependency = template:GetPropertyByName(depends_on)
        if not dependency then
            error(string.format("Property '%s' depends on unknown dependency '%s'. This should never happen!", prop:GetName(), depends_on))
        end

        if not replicated_props[depends_on] then
            return
        end
    end

    -- Check if this property has a replication condition.
    local cond = prop:GetReplicationCondition()
    if cond then
        local shouldReplicate = cond(tbl)
        net.WriteBool(shouldReplicate)

        if not shouldReplicate then
            return
        end
    end

    Replicate.Funcs["Write" .. prop:GetType()](prop, tbl[prop:GetName()])
    replicated_props[prop:GetName()] = true

end

function Replicate.ReadTable(meta)
    -- No metatable means we default to ReadTable(). 
    if not meta then
        return net.ReadTable()
    end

    -- Don't pass in anything else than a table.
    if not istable(meta) then
        error("Expected a table, got: " .. type(tbl))
        return
    end

    -- Unregistered metatable gets the ReadTable() treatment.
    if not Replicate.Templates[meta] then
        return net.ReadTable()
    end

    local template = Replicate.Templates[meta]
    local readType = net.ReadType()

    if readType == TYPE_NIL then 
        return nil
    elseif readType ~= TYPE_TABLE then 
        error("Expected TYPE_TABLE or TYPE_NIL when reading type for sanity check, got: " .. tostring(readType))
        return nil
    end

    local tbl = {}
    local replicated_props = {}
    for index, prop in ipairs(template:GetProperties()) do
        Replicate.ReadProperty(tbl, template, replicated_props, index, prop)
    end

    setmetatable(tbl, meta)
    return tbl
end

--[[
    Read a property to the net library.
    @param tbl The table to read the property to.
    @param template The replication template that holds the property to read.
    @param replicated_props An inversed table containing a list of properties that were replicated as keys.
    @param index The index of the property.
    @param prop The property to read.
--]]
function Replicate.ReadProperty(tbl, template, replicated_props, index, prop)
    local depends_on = prop:GetDependsOn()

    -- This property depends on another. Let's check that the other was replicated.
    if depends_on then
        local _, dependency = template:GetPropertyByName(depends_on)
        if not dependency then
            error(string.format("Property '%s' depends on unknown dependency '%s'. This should never happen!", prop:GetName(), depends_on))
        end

        if not replicated_props[depends_on] then
            if prop:GetDefaultValue() then
                tbl[prop:GetName()] = prop:GetDefaultValue()
            end
            return
        end
    end

    -- Check if this property has a replication condition and if it passed it.
    local cond = prop:GetReplicationCondition()
    if cond then
        local passed_condition = net.ReadBool()

        if not passed_condition then
            if prop:GetDefaultValue() then
                tbl[prop:GetName()] = prop:GetDefaultValue()
            end
            return
        end
    end

    local value = Replicate.Funcs["Read" .. prop:GetType()](prop)
    tbl[prop:GetName()] = value
    replicated_props[prop:GetName()] = true

end

--[[
    Write functions
--]]

function Replicate.Funcs.WriteString(prop, value)
    net.WriteString(value)
end

function Replicate.Funcs.WriteData(prop, value)
    net.WriteUInt(#value, prop:GetBits() or 16)
    net.WriteData(value, #value)
end

function Replicate.Funcs.WriteFloat(prop, value)
    net.WriteFloat(value)
end

function Replicate.Funcs.WriteDouble(prop, value)
    net.WriteDouble(value)
end

function Replicate.Funcs.WriteUInt(prop, value)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    net.WriteUInt(value, prop:GetBits())
end

function Replicate.Funcs.WriteInt(prop, value)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    net.WriteInt(value, prop:GetBits())
end

function Replicate.Funcs.WriteBool(prop, value)
    net.WriteBool(value)
end

function Replicate.Funcs.WriteBit(prop, value)
    net.WriteBit(value)
end

function Replicate.Funcs.WriteColor(prop, value)
    net.WriteColor(value)
end

function Replicate.Funcs.WriteVector(prop, value)
    net.WriteVector(value)
end

function Replicate.Funcs.WriteAngle(prop, value)
    net.WriteAngle(value)
end

function Replicate.Funcs.WriteEntity(prop, value)
    net.WriteEntity(value)
end

-- Haha recursion go brrrrt
function Replicate.Funcs.WriteTable(prop, value) 
    Replicate.WriteTable(value)
end

function Replicate.Funcs.WriteList(prop, value)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    net.WriteUInt(#value, prop:GetBits())

    local writeFunc = Replicate.Funcs["Write" .. prop:GetValueType()]
    for _, v in pairs(value) do
        writeFunc(prop, v)
    end
end

function Replicate.Funcs.WriteOrderedList(prop, value)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    net.WriteUInt(#value, prop:GetBits())

    local writeFunc = Replicate.Funcs["Write" .. prop:GetValueType()]
    for _, v in ipairs(value) do
        writeFunc(prop, v)
    end
end

function Replicate.Funcs.WriteValueTable(prop, value)
    local bits = prop:GetBits() or 32
    local keys = {}
    for k, v in pairs(value) do
        if v then
            values[#values + 1] = k
        end
    end

    net.WriteUInt(#keys, bits)
    for _, v in ipairs(keys) do
        net.WriteString(v)
    end
end

--[[
    Read functions
--]]

function Replicate.Funcs.ReadString(prop)
    return net.ReadString()
end

function Replicate.Funcs.ReadData(prop)
    local len = net.ReadUInt(prop:GetBits() or 16)
    return net.ReadData(len)
end

function Replicate.Funcs.ReadFloat(prop)
    return net.ReadFloat()
end

function Replicate.Funcs.ReadDouble(prop)
    return net.ReadDouble()
end

function Replicate.Funcs.ReadUInt(prop)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    return net.ReadUInt(prop:GetBits())
end

function Replicate.Funcs.ReadInt(prop)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    return net.ReadInt(prop:GetBits())
end

function Replicate.Funcs.ReadBool(prop)
    return net.ReadBool()
end

function Replicate.Funcs.ReadBit(prop)
    return net.ReadBit()
end

function Replicate.Funcs.ReadColor(prop)
    return net.ReadColor()
end

function Replicate.Funcs.ReadVector(prop)
    return net.ReadVector()
end

function Replicate.Funcs.ReadAngle(prop)
    return net.ReadAngle()
end

function Replicate.Funcs.ReadEntity(prop)
    return net.ReadEntity()
end

-- Haha recursion go brrrrt
function Replicate.Funcs.ReadTable(prop) 
    return Replicate.ReadTable(prop:GetMetaTable())
end

function Replicate.Funcs.ReadList(prop)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    local size = net.ReadUInt(prop:GetBits())
    local tbl = {}

    local ReadFunc = Replicate.Funcs["Read" .. prop:GetValueType()]
    for i = 1, size do
        tbl[i] = ReadFunc(prop)
    end

    return tbl
end

function Replicate.Funcs.ReadOrderedList(prop)
    Replicate.Assert.IsValidBitAmount(prop:GetBits())
    local size = net.ReadUInt(prop:GetBits())
    local tbl = {}

    local ReadFunc = Replicate.Funcs["Read" .. prop:GetValueType()]
    for i = 1, size do
        tbl[i] = ReadFunc(prop)
    end

    return tbl
end

function Replicate.Funcs.WriteValueTable(prop)
    local bits = prop:GetBits() or 32

    local tbl = {}
    local count = net.ReadUInt(bits)
    for i = 1, count do
        tbl[net.ReadString()] = true
    end

    return tbl
end