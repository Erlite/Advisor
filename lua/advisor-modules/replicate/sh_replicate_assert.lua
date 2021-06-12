Replicate = Replicate or {}
Replicate.Assert = Replicate.Assert or {}

function Replicate.Assert.NotNilOrEmptyString(name, argName)
    if not name or not isstring(name) or #name == 0 then
        error("Expected a valid, not empty value for argument name '" .. argName or "nil" .. "'")
    end
end

function Replicate.Assert.IsNotNil(tbl, name)
    if table == nil then
        error("Expected a non nil value for argument name '" .. name .. "'")
    end
end

function Replicate.Assert.IsValidReplicationType(type)
    if not type or not table.HasValue(ReplicationType, type) then
        error("Invalid ReplicationType value '" .. tostring(type) or "nil" .. "'")
    end
end

function Replicate.Assert.IsValidBitAmount(num)
    if not isnumber(num) or num < 1 or num > 32 then
        error("Invalid amount of bits '" .. tostring(num) or "nil" .. "'");
    end
end
