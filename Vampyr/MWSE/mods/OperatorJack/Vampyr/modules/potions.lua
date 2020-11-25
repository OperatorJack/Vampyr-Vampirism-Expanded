local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

local function registerPotions()
    framework.alchemy.createBasicPotion({
        id = common.potions.smallRestoreBlood,
        name = "Small Vial of Blood",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 10,
        max = 10,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.potions.mediumRestoreBlood,
        name = "Medium Vial of Blood",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 30,
        max = 30,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.potions.largeRestoreBlood,
        name = "Large Vial of Blood",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 50,
        max = 50,
        duration = 1
    })
end

event.register("MagickaExpanded:Register", registerPotions)