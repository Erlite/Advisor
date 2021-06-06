AddCSLuaFile()

include("moduleloader.lua")

-- Couldn't care less about overriding a useless function.
ErrorNoHalt = function(...)
    local args = {...}
    local output = table.concat(args)

    MsgC(Color(255, 90, 90), "[ERROR]: ", output, "\n")

    local level = 3

    MsgC(Color(255, 90, 90),  "\nTrace:\n")
    local spaceCount = 0
    while true do

        local info = debug.getinfo( level, "Sln" )
        if ( !info ) then break end
        local spaces = string.rep(" ", spaceCount)

        if info.name != nil and info.what != "C" then
            MsgC( Color(255, 90, 90), string.format( "%s[Line %d] at %s in %s\n", spaces, info.currentline, info.name, info.short_src) )
            spaceCount = spaceCount + 1
        end

        level = level + 1
    end

    Msg( "\n" )
end

Advisor.Modules.LoadAllModules()