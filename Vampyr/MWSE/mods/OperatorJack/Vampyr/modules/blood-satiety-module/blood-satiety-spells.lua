local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

local function registerSpells()
    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinOne,
        name = "Dead Skin (Dessicated)",
        effects = {
            [1] = {
                id = tes3.effect.weaknesstoFire,
                range = tes3.effectRange.self,
                min = 100,
                max = 100,
            }
        }
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinTwo,
        name = "Dead Skin (Torrid)",
        effects = {
            [1] = {
                id = tes3.effect.resistFrost,
                range = tes3.effectRange.self,
                min = 10,
                max = 10,
            },
            [2] = {
                id = tes3.effect.weaknesstoFire,
                range = tes3.effectRange.self,
                min = 80,
                max = 80,
            }
        }
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinThree,
        name = "Dead Skin (Drained)",
        effects = {
            [1] = {
                id = tes3.effect.resistFrost,
                range = tes3.effectRange.self,
                min = 25,
                max = 25,
            },
            [2] = {
                id = tes3.effect.weaknesstoFire,
                range = tes3.effectRange.self,
                min = 60,
                max = 60,
            }
        }
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinFour,
        name = "Dead Skin (Thirsty)",
        effects = {
            [1] = {
                id = tes3.effect.resistFrost,
                range = tes3.effectRange.self,
                min = 40,
                max = 40,
            },
            [2] = {
                id = tes3.effect.weaknesstoFire,
                range = tes3.effectRange.self,
                min = 40,
                max = 40,
            }
        }
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinFive,
        name = "Dead Skin (Uncomfortable)",
        effects = {
            [1] = {
                id = tes3.effect.resistFrost,
                range = tes3.effectRange.self,
                min = 45,
                max = 45,
            },
            [2] = {
                id = tes3.effect.weaknesstoFire,
                range = tes3.effectRange.self,
                min = 25,
                max = 25,
            }
        }
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createComplexSpell({
        id = common.spells.satiety.deadSkinSix,
        name = "Dead Skin (Satisfied)",
        effects = {
            [1] = {
                id = tes3.effect.resistFrost,
                range = tes3.effectRange.self,
                min = 50,
                max = 50,
            }
        }
    })
    spell.castType = tes3.spellType.ability
end

event.register("MagickaExpanded:Register", registerSpells)
