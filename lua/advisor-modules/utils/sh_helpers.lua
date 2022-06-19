Advisor = Advisor or {}
Advisor.Utils = Advisor.Utils or {}

function GetterFunc(tbl, key, name)
    tbl["Get" .. name] = function(self) return self[key] end
end

function Advisor.Utils.TimestampToReadableText(timestamp)
    local LOC = Advisor.Localization.Localize

    if not isnumber(timestamp) then
        error("Cannot get readable text from invalid timestamp.")
    end

    local display =
    {
        {"%Y", "year", "years"},
        {"%m", "month", "months"}, 
        {"%d", "day", "days"}, 
        {"%H", "hour", "hours"}, 
        {"%M", "minute", "minutes"},
        {"%S", "second", "seconds"},
    }
    

    for _, v in ipairs(display) do
        local epoch = tonumber(os.date(v[1], 0))
        local date = tonumber(os.date(v[1], timestamp))

        if epoch and date then
            local time = date - epoch
            if time >= 2 then
                return string.format("%s %s", time, LOC("dates", v[3]))
            elseif time == 1 then
                return string.format("%s %s", time, LOC("dates", v[2]))
            end
        end
    end

    return "0 " .. LOC("dates", "seconds")
end

function Advisor.Utils.ToStringArray(text)
    text = string.Trim(text)
    if #text == 0 then return {} end

    local args = {}
    local currentArg = ""

    local inQuote = false
    local inApostrophes = false
    local isEscaped = false

    for i = 1, #text do
        local currentChar = text:sub(i, i)
        if isEscaped then
            currentArg = currentArg .. currentChar
            isEscaped = false
            continue
        end

        local nextIndex = i + 1
        if currentChar == "\\" then
            isEscaped = true
        elseif currentChar == "'" then
            if not inQuote && (#currentArg == 0 or #text == nextIndex or text:sub(nextIndex, nextIndex) == " ") then
                inApostrophes = not inApostrophes
            else
                currentArg = currentArg .. currentChar
            end
        elseif currentChar == '"' then
            if not inApostrophes && (#currentArg == 0 or #text == nextIndex or text:sub(nextIndex, nextIndex) == " ") then
                inQuote = not inQuote
            else
                currentArg = currentArg .. currentChar
            end
        else
            if currentChar == " " then
                if inQuote or inApostrophes then
                    currentArg = currentArg .. currentChar
                elseif #currentArg ~= 0 then
                    args[#args + 1] = currentArg
                    currentArg = ""
                end
            else
                currentArg = currentArg .. currentChar
            end
        end
    end

    if inQuote or inApostrophes then
        currentArg = string.TrimRight(currentArg)
        local lastChar = currentArg:sub(#currentArg, #currentArg)
        if #currentArg > 1 and (lastChar == '"' or lastChar == "'") then 
            currentArg = currentArg:sub(1, #currentArg - 1)
        else
            -- this means a single quote/apostrophe was removed, uh oh.
            -- thankfully we can fix this, we'll just add it back to the start of this string.
            currentArg = (inQuote and '"' or "'") .. currentArg

            -- But wait, since it's supposed to be taken as a single argument, this means the current argument is supposed to be split!!
            local newArgs = string.Split(currentArg, " ")
            for j = 1, #newArgs do
                args[#args + 1] = newArgs[j]
            end

            return args
        end
    end

    args[#args + 1] = currentArg
    return args
end 

function math.LerpColor(curr, target, alpha)
    local currHSV = {ColorToHSV(curr)}
    local targetHSV = {ColorToHSV(target)}

    return HSVToColor(Lerp(alpha, currHSV[1], targetHSV[1]), Lerp(alpha, currHSV[2], targetHSV[2]), Lerp(alpha, currHSV[3], targetHSV[3]))
end