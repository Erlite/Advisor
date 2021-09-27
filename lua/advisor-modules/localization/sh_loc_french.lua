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

    Namespace("parsers")
        Key("unknown", "Aucun convertisseur défini pour le type '%s'.")
        Key("unimplemented", "Le parseur pour les arguments du type n'a pas été implémenté.")
        Key("failed_number", "Impossible de convertir '%s' en nombre valide.")
        Key("empty_string", "Impossible de convertir du texte vide en argument.")
        Key("self_is_console", "Vous ne pouvez pas vous cibler sur la console.")
        Key("no_target", "Impossible de trouver une cible.")
        Key("ambiguous_target", "Plusieurs cibles correspondent au nom donné, veuillez ré-essayer avec un nom plus précis.")
    EndNamespace()

    Namespace("commands")
        Key("unknown_command", "Commande inconnue.")
        Key("missing_argument", "Argument manquant '%s'.")
    EndNamespace()

EndLanguage()