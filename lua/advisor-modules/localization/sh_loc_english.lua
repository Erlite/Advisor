--[[
    HOW TO CREATE A NEW LANGUAGE IN FOUR EASY STEPS
    1- Create a file in the modules/localization folder called "sh_loc_yourLanguage.lua"
    2- Copy and paste the ENTIRETY of this file there
    3- Edit the Language("english") key to suit your language. Example: Language("russian")
    4- Translate the localized strings below. Your language will now be available.

    - Translating keys:
        Key("somekeyname_DONOTTOUCH", "THIS IS THE PART YOU MODIFY")
        - Do NOT modify key names or namespace names as you'll just break the localization.

    - If this file has an error the language will most likely not be available.
--]]

local Language = Advisor.Localization.Language
local EndLanguage = Advisor.Localization.EndLanguage
local Namespace = Advisor.Localization.Namespace
local EndNamespace = Advisor.Localization.EndNamespace
local Key = Advisor.Localization.Key

Language("english")    

    Namespace("users")
        Key("new_user_connected", "%s connected for the first time.")
        Key("existing_user_connected", "%s connected, last seen %s ago.")
    EndNamespace()

    Namespace("dates")
        Key("years", "years")
        Key("year", "year")
        Key("months", "months")
        Key("month", "month")
        Key("days", "days")
        Key("day", "day")
        Key("hours", "hours")
        Key("hour", "hour")
        Key("minutes", "minutes")
        Key("minute", "minute")
        Key("seconds", "seconds")
        Key("second", "second")
    EndNamespace()

    Namespace("parsers")
        Key("unknown", "No parser found for argument type '%s'.")
        Key("unimplemented", "Parser for argument type has not been implemented.")
        Key("failed_number", "Failed to parse '%s' into a valid number.")
        Key("empty_string", "Failed to parse an argument from empty or whitespace text.")
        Key("self_is_console", "You cannot target yourself on the console.")
        Key("no_target", "Could not find any target.")
        Key("ambiguous_target", "Found multiple targets from the given name, please try again with a more accurate one.")
        Key("no_time_converter", "Could not convert '%s' into a valid time unit (valid units are (s)econds, (m)inutes, (h)ours, (d)ays, (w)eeks, (mo)nths and (y)ears).")
        Key("no_time_amount", "Could not find the time amount to convert.")
    EndNamespace()

    Namespace("commands")
        Key("unknown_command", "Unknown command.")
        Key("missing_argument", "Missing argument '%s'.")
        Key("error_thrown", "An error has occured while executing command '%s': %s")
    EndNamespace()

    Namespace("ui")
        Key("category_landing", "LANDING PAGE")
        Key("category_admin", "ADMINISTRATION")
        Key("category_misc", "MISCELLANEOUS")
        Key("option_home", "Home")
        Key("option_myprofile", "My Profile")
        Key("option_settings", "Settings")
        Key("option_usergroups", "Usergroups")
        Key("option_users", "Users")
        Key("option_auditlogs", "Audit Logs")
        Key("option_bans", "Bans")
        Key("option_credits", "Credits")
        Key("option_appearance", "Appearance")
        Key("field_text_scale", "Text Scale")
    EndNamespace()

    Namespace("usergroups")
        Key("usergroup_fullcontrol_title", "Total Control")
        Key("usergroup_fullcontrol_desc", "This usergroup is entirely controlled by Advisor.")
        Key("usergroup_partialcontrol_title", "Partial Control")
        Key("usergroup_partialcontrol_desc", "This usergroup may be affected by the following addon:\n\n- %s")
        Key("usergroup_nocontrol_title", "Third Party Control")
        Key("usergroup_nocontrol_desc", "This usergroup is entirely controlled by the following addon:\n\n- %s")
    EndNamespace()

EndLanguage()