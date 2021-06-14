Advisor = Advisor or {}
Advisor.Utils = Advisor.Utils or {}

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