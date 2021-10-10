--[[
    Localization manager used to localize strings in different languages.
--]]

-- Language
CreateConVar("advisor_language", "english", { FCVAR_ARCHIVE }, "Chooses the language to use for the gamemode.")
cvars.AddChangeCallback("advisor_language", function(convar, old, new)
    local lang = new:lower()
    if old ~= new then
        if not Advisor.Localization.Languages[new] then 
            Advisor.Log.Error(LogAdvisor, "Unknown language '%s', resetting to english.")
            GetConVar("advisor_language"):SetString("english")
            return
        end
        Advisor.Localization.ConfiguredLanguage = lang
        Advisor.Log.Info(LogAdvisor, "Set language to '%s'.", lang)
    end
end, "Advisor.LanguageCallback")

Advisor = Advisor or {}
Advisor.Localization = Advisor.Localization or {}
Advisor.Localization.ConfiguredLanguage = GetConVar("advisor_language"):GetString()
Advisor.Localization.Languages = Advisor.Localization.Languages or {}

-- Used when saving new languages.
local currentLanguage = nil
local currentNamespace = nil

-- Set the language for the following localization keys.
function Advisor.Localization.Language(name)
    -- If a language is already set, this probably means the localization file prior to this one is broken.
    if currentLanguage != nil then
        -- We'll clear the table.
        Advisor.Log.Error(LogLocalization, "We most likely have a broken language '%s', check the file for lua errors.", currentLanguage)
        table.RemoveByValue(Advisor.Localization.Languages, currentLanguage)
        currentLanguage = nil
    end

    currentLanguage = name or "invalidName"
    Advisor.Log.Info( LogLocalization, "loaded language '%s'", currentLanguage )
end

function Advisor.Localization.EndLanguage()
    if not currentLanguage then
        Error( "Cannot end language: haven't started any." )
        return
    end
    currentLanguage = nil
end

function Advisor.Localization.Namespace(name)
    currentNamespace = name or "global"
end

function Advisor.Localization.EndNamespace()
    if not currentNamespace then
        Error( "Cannot end namespace: haven't started any." )
        return
    end

    currentNamespace = "global"
end

function Advisor.Localization.Key(name, value)
    if not currentLanguage then
        Error( "Cannot add key: haven't started any language." )
        return
    end
    -- Create the lang's table if it doesn't exist.
    if not Advisor.Localization.Languages[currentLanguage] then
        Advisor.Localization.Languages[currentLanguage] = {}
    end

    -- Create the namespace table if it doesn't exist.
    if not Advisor.Localization.Languages[currentLanguage][currentNamespace] then
        Advisor.Localization.Languages[currentLanguage][currentNamespace] = {}
    end

    Advisor.Localization.Languages[currentLanguage][currentNamespace][name] = value
end

-- Used to get a localized string out of a namespace and key.
function Advisor.Localization.Localize(namespace, key, ...)
    if Advisor.Localization.Languages[Advisor.Localization.ConfiguredLanguage] == nil then
        Advisor.Log.Error( LogLocalization, "Set to invalid language '%s', defaulting to english.", Advisor.Localization.ConfiguredLanguage or "nil" )
        Advisor.Localization.ConfiguredLanguage = "english"
    end
    if Advisor.Localization.Languages[Advisor.Localization.ConfiguredLanguage][namespace] != nil && Advisor.Localization.Languages[Advisor.Localization.ConfiguredLanguage][namespace][key] then
        return string.format(Advisor.Localization.Languages[Advisor.Localization.ConfiguredLanguage][namespace][key], ...)
    else
        Advisor.Log.Error( LogLocalization, "Attempted to get localization for unknown key '%s'", key )
        return string.format("#%s.%s", namespace, key)
    end
end