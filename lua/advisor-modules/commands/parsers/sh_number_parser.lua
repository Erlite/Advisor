local NumberParser = {}

function NumberParser:Parse(ctx, raw)
    local parsed = tonumber(raw)
    if not parsed then
        return false, { namespace = "parsers", key = "failed_number", args = { raw } }
    end

    return true, parsed
end

Advisor.CommandHandler.RegisterParser("number", NumberParser)