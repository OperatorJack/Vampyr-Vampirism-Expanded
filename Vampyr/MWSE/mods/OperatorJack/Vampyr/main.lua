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

require("OperatorJack.Vampyr.modules.blood-ui")
require("OperatorJack.Vampyr.modules.blood-mechanics")

require("OperatorJack.Vampyr.modules.blood-potency-ui")
require("OperatorJack.Vampyr.modules.blood-potency-mechanics")

require("OperatorJack.Vampyr.modules.blood-spells")
require("OperatorJack.Vampyr.modules.blood-spells-ui")
require("OperatorJack.Vampyr.modules.blood-spells-mechanics")

require("OperatorJack.Vampyr.modules.simulate")
require("OperatorJack.Vampyr.modules.effects")
require("OperatorJack.Vampyr.modules.spells")

require("OperatorJack.Vampyr.modules.fixNpcVampirism")
require("OperatorJack.Vampyr.modules.potions")
require("OperatorJack.Vampyr.modules.shadowstep")
require("OperatorJack.Vampyr.modules.stakes")

require("OperatorJack.Vampyr.modules.claws")


require("OperatorJack.Vampyr.modules.memory-overrides.sun-damage")
require("OperatorJack.Vampyr.modules.memory-overrides.turn-undead")

require("OperatorJack.Vampyr.modules.scriptOverrides")


event.register("initialized", function(e)
    common.logger.info("Initialized.")
end)