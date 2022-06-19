Advisor = Advisor or {}
Advisor.ArgumentParser = {}

--[[
    Parse the given argument into a table.
    @param ctx The context of the command being executed.
    @param raw The raw argument to parse into the desired result.
    @returns Success (bool), Result (table) or a localized error table ({namespace = string, key = string})
--]]
function Advisor.ArgumentParser:Parse(ctx, raw)
    return false, { namespace = "parsers", key = "unimplemented" }
end

function Advisor.ArgumentParser:Autocomplete(cmdArg, rawArg)
    if #rawArg:Trim() == 0 then
     local auto = { "[" .. cmdArg:GetName() .. "]" }
     if #cmdArg:GetDescription() ~= 0 then 
         auto = { "[" .. cmdArg:GetName() .. "]: " .. cmdArg:GetDescription() }
     end
     return auto
    end 

    return {}
end

--[[ 
    Get the default value when the Argument is set as optional without a set default value
    @param ctx The context of the command being executed.
    @returns Value (any)
--]]
function Advisor.ArgumentParser:GetDefault(ctx)
    return nil
end