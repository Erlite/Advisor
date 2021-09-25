local NumberParser = {}

function NumberParser:Parse(ctx, argType, raw)
    local LOC = Advisor.Localization.Localize

    local parsed = tonumber(raw)
    if not parsed then
        return false, { namespace = "parsers", key = "failed_number" }
    end

    return true, parsed
end

Advisor.CommandHandler.RegisterParser("number", NumberParser)