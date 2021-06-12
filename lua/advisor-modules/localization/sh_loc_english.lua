--[[
    HOW TO CREATE A NEW LANGUAGE IN FOUR EASY STEPS
    1- Create a file in the modules/localization folder called "sh_loc_yourLanguage.lua"
    2- Copy and paste the ENTIRETY of this file there
    3- Edit the Language("english") key to suit your language. Example: Language("russian")
    4- Translate the localized strings below. Your language will now be available.

    - Translating keys:
        Key("playerhasfaction", "THIS IS THE PART YOU MODIFY")
        - Do NOT modify key names or namespace names as you'll just break the localization.

    - If this file has an error the language will most likely not be available.
--]]

local Language = Advisor.Localization.Language
local EndLanguage = Advisor.Localization.EndLanguage
local Namespace = Advisor.Localization.Namespace
local EndNamespace = Advisor.Localization.EndNamespace
local Key = Advisor.Localization.Key

Language("english")    
EndLanguage()