local framework = require("OperatorJack.MagickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local bloodExtraction = require("OperatorJack.Vampyr.modules.functions.blood-extraction")

local function createPotions()
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

event.register("MagickaExpanded:Register", createPotions)

local function registerSerums()
    bloodExtraction.registerSerum({
        serumId = common.ids.serums.mini,
        emptySerumId = common.ids.serums.mini .. "_e",
        applyHealthDamage = 5
    })
    bloodExtraction.registerSerum({
        serumId = common.ids.serums.small,
        emptySerumId = common.ids.serums.small .. "_e",
        applyHealthDamage = 10
    })
    bloodExtraction.registerSerum({
        serumId = common.ids.serums.medium,
        emptySerumId = common.ids.serums.medium .. "_e",
        applyHealthDamage = 20
    })
    bloodExtraction.registerSerum({
        serumId = common.ids.serums.large,
        emptySerumId = common.ids.serums.large .. "_e",
        applyHealthDamage = 40
    })
    bloodExtraction.registerSerum({
        serumId = common.ids.serums.decanter,
        emptySerumId = common.ids.serums.decanter .. "_e",
        applyHealthDamage = 80
    })
end
event.register(common.events.registerSerums, registerSerums)
