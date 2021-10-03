local PlayerParser = {}

function PlayerParser:Parse(ctx, rawArgument)
    local arg = string.Trim(rawArgument)
    local sender = ctx:GetSender()
    local plys = {}
    local allPlayers = player.GetAll()

    if not isstring(arg) or #arg == 0 then 
        return false, { namespace = "parsers", key = "empty_string" }
    end

    -- Target self
    if arg == "^" then
        if sender then
            -- {{}} is on purpose - players are always a list, even with a single player.
            return true, {{ steamid = sender:SteamID64(), ply = sender }}
        end

        return false, { namespace = "parsers", key = "self_is_console" }
    end

    -- Target everyone except yourself
    if arg == "!^" then
        for _, v in ipairs(allPlayers) do
            if not sender or v ~= sender then
                plys[#plys + 1] = { steamid = v:SteamID64(), ply = v }
            end
        end

        if #plys > 0 then 
            return true, plys
        end 

        return false, { namespace = "parsers", key = "no_target" }
    end

    -- Target all players on the server.
    if arg == "*" then
        for _, v in ipairs(allPlayers) do 
            plys[#plys + 1] = { steamid = v:SteamID64(), ply = v } 
        end

        if #plys > 0 then
            return true, plys
        end

        return false, { namespace = "parsers", key = "no_target" }
    end

    -- Target the player you're looking at.
    if arg == "@" then
        if not sender then
            return false, { namespace = "parsers", key = "no_target" }
        end

        local ent = sender:GetEyeTraceNoCursor().Entity
        if IsValid(ent) and ent:IsPlayer() then
            return true, {{ steamid = ent:SteamID64(), ply = ent }}
        else
            return false, { namespace = "parsers", key = "no_target" }
        end
    end

    -- Find by SteamID
    -- Check if the argument is a steamid (and parse it to a steamid64 if it isn't one already)
    -- Since Lua patterns are dumb compared to regex, this will have to do.
    local steamid64
    if string.StartWith(arg, "7656") and tonumber(arg) and #arg == 17 then
        steamid64 = arg
    else
        steamid64 = util.SteamIDTo64(arg)
        if steamid64 == "0" then steamid64 = nil end
    end

    if steamid64 then
        local foundPly = player.GetBySteamID64(steamid64)
        return true, {{ steamid = steamid64, ply = foundPly }}
    end

    local lowArg = arg:lower()

    -- Find by exact name match (case insensitive)
    for _, v in ipairs(allPlayers) do
        if v:Name():lower() == lowArg then 
            return true, {{ steamid = v:SteamID64(), ply = v }}
        end
    end

    -- Find by approximate name
    -- Only allow if there's only one possible player.
    for _, v in ipairs(allPlayers) do
        local foundPos, endPos, _ = string.find(v:Name():lower(), lowArg)
        if foundPos ~= nil then
            plys[#plys + 1] = { steamid = v:SteamID64(), ply = v } 
        end
    end

    if #plys == 1 then
        return true, plys
    elseif #plys > 1 then
        return false, { namespace = "parsers", key = "ambiguous_target" }
    end

    return false, { namespace = "parsers", key = "no_target" }
end

function PlayerParser:Autocomplete(arg, rawArg)
    rawArg = rawArg:Trim()
    local found = 
    {
        "*",
        "^",
        "!^", 
        "@",
    }

    for _, ply in ipairs(player.GetAll()) do
        local contains = string.find(ply:Nick():lower(), rawArg, 1, true)
        if contains then 
            found[#found + 1] = string.format('"%s"', ply:Nick())
        end
    end

    return found
end

Advisor.CommandHandler.RegisterParser("player", PlayerParser)