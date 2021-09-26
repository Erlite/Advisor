local StringParser = {}

-- Not particularly useful, but good if we want to handle something in here in the future.
function StringParser:Parse(ctx, rawArgument)
    return true, rawArgument
end

Advisor.CommandHandler.RegisterParser("text", StringParser)
Advisor.CommandHandler.RegisterParser("string", StringParser)