local bloodSpells = require("OperatorJack.Vampyr.modules.blood-spells-module.blood-spells")

local function onSpellCast(e)
    local bloodSpell = bloodSpells.getBloodSpellConfigurationBySpellId(e.source.id)
    if (not bloodSpell) then
        return
    end

    local canCastSpell = bloodSpells.isReferenceAbleToCastBloodMagic(e.caster, bloodSpell.cost)

    if (canCastSpell == false) then
        e.castChance = 0
        if (e.caster == tes3.player) then
            bloodSpells.changeSpellFailedMessageBoxForFrame()
        end
    else
        e.castChance = 100
        bloodSpells.applyBloodMagicCostForReference(e.caster, bloodSpell.cost)
    end

    e.claim = true
end
event.register("spellCast", onSpellCast, {priority = 1000})