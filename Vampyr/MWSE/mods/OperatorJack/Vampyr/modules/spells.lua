local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

local function registerSpells()
    framework.spells.createBasicSpell({
        id = common.spells.restoreBlood,
        name = "Restore Blood",
        effect = tes3.effect.restoreBlood,
        range = tes3.effectRange.self,
        min = 5,
        max = 5,
        duration = 10
    })
    framework.spells.createBasicSpell({
        id = common.spells.drainBlood,
        name = "Drain Blood",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.target,
        min = 5,
        max = 5,
        duration = 10
    })

    local spell = framework.spells.createBasicSpell({
        id = common.spells.transfusion,
        name = "Transfusion",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.touch,
        min = 10,
        max = 10,
        duration = 5
    })
    spell.castType = tes3.spellType.power

    local spell = framework.spells.createBasicSpell({
        id = common.spells.weakVampiricTouch,
        name = "Weak Vampiric Touch",
        effect = tes3.effect.fortifyClaws,
        range = tes3.effectRange.self,
        min = 20,
        max = 20
    })
    spell.castType = tes3.spellType.ability

    framework.spells.createBasicSpell({
        id = common.spells.weakVampiricKiss,
        name = "Weak Vampiric Kiss",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.touch,
        min = 5,
        max = 5,
        duration = 1
    })

    local spell = framework.spells.createBasicSpell({
        id = common.spells.lesserVampiricTouch,
        name = "Lesser Vampiric Touch",
        effect = tes3.effect.fortifyClaws,
        range = tes3.effectRange.self,
        min = 35,
        max = 35
    })
    spell.castType = tes3.spellType.ability

    framework.spells.createBasicSpell({
        id = common.spells.lesserVampiricKiss,
        name = "Lesser Vampiric Kiss",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.touch,
        min = 15,
        max = 15,
        duration = 1
    })

    local spell = framework.spells.createBasicSpell({
        id = common.spells.vampiricTouch,
        name = "Vampiric Touch",
        effect = tes3.effect.fortifyClaws,
        range = tes3.effectRange.self,
        min = 50,
        max = 50
    })
    spell.castType = tes3.spellType.ability

    framework.spells.createBasicSpell({
        id = common.spells.vampiricKiss,
        name = "Vampiric Kiss",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.touch,
        min = 25,
        max = 25,
        duration = 1
    })

    local spell = framework.spells.createBasicSpell({
        id = common.spells.greaterVampiricTouch,
        name = "Greater Vampiric Touch",
        effect = tes3.effect.fortifyClaws,
        range = tes3.effectRange.self,
        min = 80,
        max = 80
    })
    spell.castType = tes3.spellType.ability

    framework.spells.createBasicSpell({
        id = common.spells.greaterVampiricKiss,
        name = "Greater Vampiric Kiss",
        effect = tes3.effect.drainBlood,
        range = tes3.effectRange.touch,
        min = 100,
        max = 100,
        duration = 1
    })
    local spell = framework.spells.createBasicSpell({
        id = common.spells.glamour,
        name = "Glamour",
        effect = tes3.effect.glamour,
        range = tes3.effectRange.self,
    })
    spell.castType = tes3.spellType.ability

    local spell = framework.spells.createBasicSpell({
        id = common.spells.vampiricIntuition,
        name = "Vampiric Intuition",
        effect = tes3.effect.auspex,
        range = tes3.effectRange.self,
    })
    spell.castType = tes3.spellType.ability
end

event.register("MagickaExpanded:Register", registerSpells)

local function registerBloodSpells()
    framework.spells.createBasicSpell({
        id = common.bloodSpells.mirage.id,
        name = "Mirage",
        effect = tes3.effect.glamour,
        range = tes3.effectRange.self,
        duration = 30
    })
    framework.spells.createBasicSpell({
        id = common.bloodSpells.mistform.id,
        name = "Mistform",
        effect = tes3.effect.mistform,
        range = tes3.effectRange.self,
        duration = 15
    })
    framework.spells.createBasicSpell({
        id = common.bloodSpells.enslave.id,
        name = "Enslave",
        effect = tes3.effect.restoreHealth,
        range = tes3.effectRange.self,
        min = 1,
        max = 1,
        duration = 1
    })
    framework.spells.createBasicSpell({
        id = common.bloodSpells.bloodstorm.id,
        name = "Bloodstorm",
        effect = tes3.effect.bloodstorm,
        range = tes3.effectRange.self,
        duration = 60
    })
    local spell = framework.spells.createBasicSpell({
        id = common.bloodSpells.resistSunDamage20.id,
        name = "Resistance to Sun Damage",
        effect = tes3.effect.resistSunDamage,
        range = tes3.effectRange.self,
        min = 20,
        max = 20
    })
    spell.castType = tes3.spellType.ability

    spell = framework.spells.createBasicSpell({
        id = common.bloodSpells.resistSunDamage35.id,
        name = "Resistance to Sun Damage",
        effect = tes3.effect.resistSunDamage,
        range = tes3.effectRange.self,
        min = 35,
        max = 35
    })
    spell.castType = tes3.spellType.ability

    spell = framework.spells.createBasicSpell({
        id = common.bloodSpells.resistSunDamage50.id,
        name = "Resistance to Sun Damage",
        effect = tes3.effect.resistSunDamage,
        range = tes3.effectRange.self,
        min = 50,
        max = 50
    })
    spell.castType = tes3.spellType.ability

    spell = framework.spells.createBasicSpell({
        id = common.bloodSpells.immunitySunDamage.id,
        name = "Immunity to Sun Damage",
        effect = tes3.effect.resistSunDamage,
        range = tes3.effectRange.self,
        min = 100,
        max = 100
    })
    spell.castType = tes3.spellType.ability

end
event.register("MagickaExpanded:Register", registerBloodSpells)