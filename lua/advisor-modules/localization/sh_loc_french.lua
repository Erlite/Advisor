-- © Copyright 2021 Younes Meziane. All Rights Reserved.

local Language = Advisor.Localization.Language
local EndLanguage = Advisor.Localization.EndLanguage
local Namespace = Advisor.Localization.Namespace
local EndNamespace = Advisor.Localization.EndNamespace
local Key = Advisor.Localization.Key

Language("french")

    Namespace("users")
        Key("new_user_connected", "%s s'est connecté pour la première fois.")
        Key("existing_user_connected", "%s s'est connecté, dernière connection il y a %s.")
    EndNamespace()

    Namespace("dates")
        Key("years", "ans")
        Key("year", "an")
        Key("months", "mois")
        Key("month", "mois")
        Key("days", "jours")
        Key("day", "jour")
        Key("hours", "heures")
        Key("hour", "heure")
        Key("minutes", "minutes")
        Key("minute", "minute")
        Key("seconds", "secondes")
        Key("second", "seconde")
    EndNamespace()

EndLanguage()