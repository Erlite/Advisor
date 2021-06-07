AddCSLuaFile()

--[[
    Every module folder must have a configuration file.
    The name of the file must be module_[modulename].lua (e.g. module_logging.lua)
    Check out advisor-modules/logging/module_logging.lua for an example.
--]]

Module = {}
Module.__index = Module

function Module:new(tbl)
    -- If inName is a table and the other arguments are nil, this means we need to set the table's metadata to a Module and validate it.
    if tbl and istable(tbl) then
        setmetatable(tbl, Module)
        if tbl:Validate() then
            return tbl
        else
            error("Invalid copy constructor used (invalid/nil table)")
            return nil
        end
    end
end

function Module:GetName()
    return self.name
end

function Module:GetDescription()
    return self.description
end

function Module:GetLoadOrder()
    return self.loadOrder
end

function Module:Validate()
    return self.name && #self.name != 0 && self.description && #self.description != 0 && self.loadOrder
end

setmetatable(Module, {__call = Module.new})