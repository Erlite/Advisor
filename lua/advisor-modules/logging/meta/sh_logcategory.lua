LogCategory = {}
LogCategory.__index = LogCategory

function LogCategory:new(inName, inDefaultVerbosity)
    local lc = 
    {
        name = inName,
        defaultVerbosity = inDefaultVerbosity
    }
    setmetatable(lc, LogCategory)
    return lc
end

-- Get the category's "friendly name"
function LogCategory:GetName()
    return self.name
end

-- Get the category's default verbosity.
function LogCategory:GetDefaultVerbosity()
    return self.defaultVerbosity
end

setmetatable(LogCategory, {__call = LogCategory.new})