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