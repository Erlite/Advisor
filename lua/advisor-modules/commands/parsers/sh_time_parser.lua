local TimeParser = {}

local converter = {}
converter.s = 1
converter.m = 60
converter.h = converter.m * 60
converter.d = converter.h * 24
converter.w = converter.d * 7
converter.mo = converter.d * 30
converter.y = converter.d * 365

function TimeParser:Parse(ctx, raw)
    if raw:Trim() == "" then
        return false, { namespace = "parsers", key = "empty_string" }    
    end

    -- Initialize time
    local parsedTime = 0

    -- Convert given time
    local isConvertingNumber = true
    local amount, converterType = "", ""
    for i = 1, #raw do
        local letter = raw:sub( i, i )
        
        local number = tonumber( letter )
        -- Append number to amount
        if number then
            -- Add current parsed time
            if not isConvertingNumber then
                number = tonumber( amount )
                if converter[converterType] then
                    parsedTime = parsedTime + number * converter[converterType]
                else
                    return false, { namespace = "parsers", key = "no_time_converter", args = { converterType } }
                end

                amount, converterType = "", ""
            end

            amount = amount .. letter
            isConvertingNumber = true
        -- Append letter to converter type
        else
            converterType = converterType .. letter
            isConvertingNumber = false
        end
    end

    -- Convert remaining time
    if #amount > 0 then
        local number = tonumber( amount )
        if #converterType > 0 then
            if converter[converterType] then
                parsedTime = parsedTime + number * converter[converterType]
            else
                return false, { namespace = "parsers", key = "no_time_converter", args = { converterType } }
            end
        else
            -- Convert to seconds
            parsedTime = parsedTime + number
        end
    elseif #converterType > 0 then
        return false, { namespace = "parsers", key = "no_time_amount", args = { converterType } }
    end

    return true, parsedTime
end

Advisor.CommandHandler.RegisterParser("time", TimeParser)
Advisor.CommandHandler.RegisterParser("duration", TimeParser)