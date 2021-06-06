LogVerbosity = {}
LogVerbosity.__index = LogVerbosity

function LogVerbosity:new(inId, inName, inColor)
    local lv = 
    {
        id = inId,
        name = inName, 
        color = inColor
    }

    setmetatable(lv, LogVerbosity)
    return lv
end

-- Get this log verbosity's id. Use it to check verbosities against one another.
-- Example: Verbose < Info should be true.
function LogVerbosity:GetID()
    return self.id
end

-- Get this log verbosity's print name.
function LogVerbosity:GetName()
    return self.name
end

-- Get this log verbosity's print color.
function LogVerbosity:GetColor()
    return self.color
end

setmetatable(LogVerbosity, {__call = LogVerbosity.new})