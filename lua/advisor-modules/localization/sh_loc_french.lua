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
        Key("no_time_converter", "Impossible de convertir '%s' dans une unité de temps valide (parmis les (s)econdes, (m)inutes, (h)eures, (d) jours, (w) semaines, (mo)is et les (y) années).")
        Key("no_time_amount", "Impossible de trouver le temps à convertir.")
    EndNamespace()

    Namespace("commands")
        Key("unknown_command", "Commande inconnue.")
        Key("missing_argument", "Argument manquant '%s'.")
        Key("error_thrown", "Une erreur est survenue pendant l'exécution de la commande '%s': %s")
    EndNamespace()

    Namespace("ui")
        Key("category_landing", "PAGE D'ACCUEIL")
        Key("category_admin", "ADMINISTRATION")
        Key("category_misc", "DIVERS")
        Key("option_home", "Accueil")
        Key("option_myprofile", "Mon Profil")
        Key("option_settings", "Paramètres")
        Key("option_usergroups", "Groupes d'Utilisateurs")
        Key("option_users", "Utilisateurs")
        Key("option_auditlogs", "Journal d'Audit")
        Key("option_bans", "Bannissements")
        Key("option_credits", "Crédits")
    EndNamespace()

EndLanguage()