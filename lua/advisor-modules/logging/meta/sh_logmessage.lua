LogMessage = {}
LogMessage.__index = LogMessage

function LogMessage:new(cat, verb, msg)
    if getmetatable(cat) != LogCategory then
        debug.Trace()
        Error("Invalid log category was given ")
        return nil
    end
    
    if getmetatable(verb) != LogVerbosity then
        Error("Invalid log verbosity was given.")
        return nil
    end
    
    local lm = 
    {
        category = cat,
        verbosity = verb,
        message = tostring(msg)
    }

    setmetatable(lm, LogMessage)
    return lm
end

function LogMessage:GetCategory()
    return self.category
end

function LogMessage:GetVerbosity()
    return self.verbosity
end

function LogMessage:GetMessage()
    return self.message
end

-- The name of the file this log message was created in
function LogMessage:GetSourceFile()
    return self.sourceFile
end

-- Set the name of the file which called the log instance that created this log message.
function LogMessage:SetSourceFile(name)
    self.sourceFile = name
end

-- The name of the function this log message was created in.
function LogMessage:GetSourceFunction()
    return self.sourceFunc
end

-- Set the name of the function which called the log instance that created this log message.
function LogMessage:SetSourceFunction(name)
    self.sourceFunc = name
end

setmetatable(LogMessage, {__call = LogMessage.new})