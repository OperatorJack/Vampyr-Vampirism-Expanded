-- Check MWSE Build --
if (mwse.buildDate == nil) or (mwse.buildDate < 20200122) then
    local function warning()
        tes3.messageBox(
            "[Vampyr: ERROR] Your MWSE is out of date!"
            .. " You will need to update to a more recent version to use this mod."
        )
    end
    event.register("initialized", warning)
    event.register("loaded", warning)
    return
end
----------------------------

-- Check Magicka Expanded framework.
local framework = include("OperatorJack.MagickaExpanded.magickaExpanded")
if (framework == nil) then
    local function warning()
        tes3.messageBox(
            "[Vampyr: ERROR] Magicka Expanded framework is not installed!"
            .. " You will need to install it to use this mod."
        )
    end
    event.register("initialized", warning)
    event.register("loaded", warning)
    return
end
----------------------------
local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")

-- Register the mod config menu (using EasyMCM library).
event.register("modConfigReady", function()
    dofile("Data Files\\MWSE\\mods\\OperatorJack\\Vampyr\\mcm.lua")
end)

require("OperatorJack.Vampyr.modules.blood-module.blood-ui")
require("OperatorJack.Vampyr.modules.blood-module.blood-mechanics")

require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency-ui")
require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency-mechanics")

require("OperatorJack.Vampyr.modules.blood-spells-module.blood-spells")
require("OperatorJack.Vampyr.modules.blood-spells-module.blood-spells-ui")
require("OperatorJack.Vampyr.modules.blood-spells-module.blood-spells-mechanics")

require("OperatorJack.Vampyr.modules.magic.shadowstep")
require("OperatorJack.Vampyr.modules.magic.spells")

require("OperatorJack.Vampyr.modules.alchemy.serums")

require("OperatorJack.Vampyr.modules.combat.stakes")
require("OperatorJack.Vampyr.modules.combat.feeding")
require("OperatorJack.Vampyr.modules.combat.claws")

require("OperatorJack.Vampyr.modules.simulate")
require("OperatorJack.Vampyr.modules.effects")

require("OperatorJack.Vampyr.modules.services.merchants")
require("OperatorJack.Vampyr.modules.services.prices")

require("OperatorJack.Vampyr.modules.vanilla-overides.fix-npc-vampirism")
require("OperatorJack.Vampyr.modules.vanilla-overides.sun-damage")
require("OperatorJack.Vampyr.modules.vanilla-overides.turn-undead")
require("OperatorJack.Vampyr.modules.vanilla-overides.dialogue-pc-vampire")

require("OperatorJack.Vampyr.modules.scriptOverrides")
require("OperatorJack.Vampyr.modules.functions.globals")
require("OperatorJack.Vampyr.modules.functions.debug-menu")


event.register("initialized", function(e)
    common.logger.info("Initialized.")
end)