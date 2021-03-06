AddCSLuaFile()

--[[
    This is the configuration table for our module loader.
    Feel free to change the load order of *your* modules.
--]]

loaderConfig = 
{
    splash = -- Super duper cool splash screen for cool kids like us.
    {
        "",
        "  %@@@@@@@@@@@@@@@",
        "  ///@@@   @@@@@@@",
        "  /////@@@     @@@",
        "  ////////   @@@@@",
        "  //////  ./  @@@@",
        "  ////   ////  @@@",
        "  ///////////////@",
        "",
        "",
        " - Advisor",
        " - An open source and expandable administration framework for your Garry's Mod servers and addons.",
        " - https://github.com/Erlite/gmod-advisor/"
    },
                             
    --[[
        Load order for modules. DO NOT MODIFY THE ORDER OF THE MODULES. 
        If you modify the order, we'll just assume you know what you're doing and you're void of our help, really.
        Same goes for modifying our module_name.lua files.
    --]]
    loadOrder =
    {
        "utils", -- Miscellaneous utilities.
        "logging", -- Advisor's logging module which is just about used by everything.
        "localization", -- Localization module used to translate 
        "replicate", -- A high performance networking library for tables.
        "metatables", -- Advisor's metatables.
        "sql", -- Advisor's data persistence module.
        "framework", -- Advisor's core module.
    },

    -- Use this to disable modules if you wanna.
    ignoredModules = 
    {
        -- "someModuleName",
    }
}