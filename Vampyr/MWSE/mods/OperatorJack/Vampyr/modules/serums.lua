local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

local function registerPotions()
    framework.alchemy.createBasicPotion({
        id = common.ids.serums.mini,
        name = "Blood Serum Tube",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 5,
        max = 5,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.ids.serums.small,
        name = "Blood Serum Vial",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 10,
        max = 10,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.ids.serums.medium,
        name = "Blood Serum Canister",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 20,
        max = 20,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.ids.serums.large,
        name = "Blood Serum Bottle",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 40,
        max = 40,
        duration = 1
    })
    framework.alchemy.createBasicPotion({
        id = common.ids.serums.decanter,
        name = "Blood Serum Decanter",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 80,
        max = 80,
        duration = 1
    })
end

event.register("MagickaExpanded:Register", registerPotions)