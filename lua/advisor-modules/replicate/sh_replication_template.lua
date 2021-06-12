ReplicationTemplate = {}
ReplicationTemplate.__index = ReplicationTemplate

function ReplicationTemplate:new()
    local tbl =
    {
        properties = {},
        name = nil,
    }

    setmetatable(tbl, ReplicationTemplate)
    return tbl
end

AccessorFunc(ReplicationTemplate, "properties", "Properties")
AccessorFunc(ReplicationTemplate, "name", "Name", FORCE_STRING)

function ReplicationTemplate:IsEmpty()
    return #self.properties == 0
end

function ReplicationTemplate:AddProperty(prop)
    Replicate.Assert.IsNotNil(prop, "RepProperty")

    if getmetatable(prop) ~= RepProperty then
        error("Expected a RepProperty, got: " .. type(prop))
    end

    prop:AssertValid()

    -- Overwrite an existing one in case of a hot reload.
    for k, v in ipairs(self.properties) do
        if v:GetName() == prop:GetName() then
            self.properties[k] = prop
            return prop
        end
    end

    self.properties[#self.properties + 1] = prop
    return prop
end

function ReplicationTemplate:AddString(name)
    local prop = RepProperty(name, ReplicationType.String)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddData(name)
    local prop = RepProperty(name, ReplicationType.Data)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddFloat(name)
    local prop = RepProperty(name, ReplicationType.Float)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddDouble(name)
    local prop = RepProperty(name, ReplicationType.Double)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddInt(name, bits)
    local b = bits or 32

    local prop = RepProperty(name, ReplicationType.Int)
    prop:SetBits(b)

    return self:AddProperty(prop)
end

function ReplicationTemplate:AddUInt(name, bits)
    local b = bits or 32

    local prop = RepProperty(name, ReplicationType.UInt)
    prop:SetBits(b)

    return self:AddProperty(prop)
end

function ReplicationTemplate:AddBool(name)
    local prop = RepProperty(name, ReplicationType.Bool)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddBit(name)
    local prop = RepProperty(name, ReplicationType.Bit)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddColor(name)
    local prop = RepProperty(name, ReplicationType.Color)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddVector(name)
    local prop = RepProperty(name, ReplicationType.Vector)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddNormal(name)
    local prop = RepProperty(name, ReplicationType.Normal)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddMatrix(name)
    local prop = RepProperty(name, ReplicationType.Matrix)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddAngle(name)
    local prop = RepProperty(name, ReplicationType.Angle)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddEntity(name)
    local prop = RepProperty(name, ReplicationType.Entity)
    return self:AddProperty(prop)
end

function ReplicationTemplate:AddTable(name, metatable)
    local prop = RepProperty(name, ReplicationType.Table)
    prop:SetMetaTable(metatable)
    return self:AddProperty(prop)
end

-- Value Type: the type of the list's values.
-- Bits: the amount of bits that represents the max amount of values. Defaults to 16
function ReplicationTemplate:AddList(name, valueType, bits)
    bits = (bits and isnumber(bits)) and bits or 16

    local prop = RepProperty(name, ReplicationType.List)
    prop:SetValueType(valueType)
    prop:SetBits(bits)

    return self:AddProperty(prop)
end

function ReplicationTemplate:AddOrderedList(name, valueType, bits)
    bits = (bits and isnumber(bits)) and bits or 16
    local prop = RepProperty(name, ReplicationType.OrderedList)
    prop:SetValueType(valueType)
    prop:SetBits(bits)

    return self:AddProperty(prop)
end

-- Validates the template.
function ReplicationTemplate:AssertValid()
    for key, prop in ipairs(self:GetProperties()) do
        prop:AssertValid()

        -- Make sure this property doesn't depend on a property that doesn't exist, or is registered after this one.
        local depends_on = prop:GetDependsOn()
        if depends_on then
            local idx, depend_prop = self:GetPropertyByName(depends_on)
            if not depend_prop then
                error(string.format("Property '%s' cannot depend on unknown property '%s'", prop:GetName(), depends_on))
            end

            if idx == key then
                error(string.format("Property '%s' cannot depend on itself."), prop:GetName())
            end

            if idx > key then
                error(string.format("Property '%s' cannot depend on '%s' as it is registered after it.", prop:GetName(), depends_on))
            end
        end
    end
end

-- Returns the index and property it finds from the given name.
-- If none are found, returns -1, nil
function ReplicationTemplate:GetPropertyByName(name)
    Replicate.Assert.NotNilOrEmptyString(name)

    for key, prop in ipairs(self:GetProperties()) do
        if prop:GetName() == name then
            return key, prop
        end
    end

    return -1, nil
end

setmetatable(ReplicationTemplate, {__call = ReplicationTemplate.new})