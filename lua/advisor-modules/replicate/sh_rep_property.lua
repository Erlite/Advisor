RepProperty = {}
RepProperty.__index = RepProperty

local function FluentAccessorFunc(tab, varname, name, iForce)
    if ( !tab ) then debug.Trace() end

	tab[ "Get" .. name ] = function( self ) return self[ varname ] end

	if ( iForce == FORCE_STRING ) then
		tab[ "Set" .. name ] = function( self, v ) 
            self[ varname ] = tostring( v )
            return self
        end
	return end

	if ( iForce == FORCE_NUMBER ) then
		tab[ "Set" .. name ] = function( self, v ) 
            self[ varname ] = tonumber( v )
            return self
        end
	return end

	if ( iForce == FORCE_BOOL ) then
		tab[ "Set" .. name ] = 
        function( self, v ) 
            self[ varname ] = tobool( v )
            return self
        end
	return end

	tab[ "Set" .. name ] = function( self, v )
        self[ varname ] = v
        return self
    end
end

-- TODO: Add Key/Value type
ReplicationType = 
{
    String = "String", -- A string property.
    Data = "Data", -- Binary data, 64kb max due to net message restrictions.
    Float = "Float", -- A float (decimal) value.
    Double = "Double", -- A double precision number.
    UInt = "UInt", -- An unsigned integer. Requires the amount of bits to be specified, or it will default to 32.
    Int = "Int", -- A signed integer. Requires the amount of bits to be specified, or it will default to 32.
    Bool = "Bool", -- A boolean, same as a bit value behind the scenes.
    Bit = "Bit", -- A single bit
    Color = "Color", -- A color (RGBA)
    Vector = "Vector", -- A Vector value (X Y Z)
    Normal = "Normal", -- A normalized vector (values must range from 0.0 to 1.0 in all components)
    Matrix = "VMatrix", -- A 4x4 matrix,
    Angle = "Angle", -- An angle.
    Entity = "Entity", -- An entity (internally, networks the EntIndex() using 16 bits)
    Table = "Table", -- Table properties must also be setup with Replicate, else it'll default to Read/WriteTable. You don't want that, do you?
    List = "List", -- A simple list, considered not ordered. Will be written as an ordinal list.
    OrderedList = "OrderedList", -- A simple list with ordered numerical keys (first key must be 1),
    ValueTable = "ValueTable", -- A key -> bool table, will only read and write keys that have true values. Keys are assumed to be strings.
}

function RepProperty:new(inName, inType)
    local tbl =
    {
        name = inName,
        type = inType,
        bits = nil,
        value_type = nil,
        condition = nil,
        depends_on = nil,
        default_value = nil,
        meta_table = nil,
    }

    setmetatable(tbl, RepProperty)
    return tbl
end

-- Key name of the property
FluentAccessorFunc(RepProperty, "name", "Name")
-- ReplicationType of the property.
FluentAccessorFunc(RepProperty, "type", "Type")
-- Amount of bits used for integers
FluentAccessorFunc(RepProperty, "bits", "Bits")
-- The ReplicationType of the value for lists.
FluentAccessorFunc(RepProperty, "value_type", "ValueType")
-- The condition in which this property will be written. A single bit will be written to determine whether or not the prop was replicated.
-- function(tbl), return true if the property should be written.
-- Only called when writing a table.
FluentAccessorFunc(RepProperty, "condition", "ReplicationCondition")
-- If not nil, the RepProperty name this property depends on. It will only be written/read if the dependency's condition is true. 
-- Only works if the dependency has a replication condition.
FluentAccessorFunc(RepProperty, "depends_on", "DependsOn")
-- The default value to assign to this property if it does not get replicated (useful for props with a condition or that depend on another)
FluentAccessorFunc(RepProperty, "default_value", "DefaultValue")
-- The meta table of a table property if any.
-- Used when reading tables. If nil or unregistered, net.ReadTable() will be used.
FluentAccessorFunc(RepProperty, "meta_table", "MetaTable")


function RepProperty:AssertValid()
    local t = self:GetType()
    Replicate.Assert.NotNilOrEmptyString(self:GetName(), "Name")
    Replicate.Assert.IsValidReplicationType(t)

    if t == ReplicationType.Int or t == ReplicationType.UInt then
        Replicate.Assert.IsValidBitAmount(self:GetBits())
    end

    if t == ReplicationType.List or t == ReplicationType.OrderedList then
        Replicate.Assert.IsValidReplicationType(self:GetValueType())
        Replicate.Assert.IsValidBitAmount(self:GetBits())
    end

    local cond = self:GetReplicationCondition()
    if cond and not isfunction(cond) then
        error("Replication Condition must be a function.")
    end
end

setmetatable(RepProperty, {__call = RepProperty.new})