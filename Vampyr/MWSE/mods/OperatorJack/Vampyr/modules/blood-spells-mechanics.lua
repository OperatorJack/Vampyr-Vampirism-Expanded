local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

local function onSpellCast(e)
    local bloodSpellKey = common.getKeyFromValueFunc(common.bloodSpells, function(value) 
        if (value.id == e.source.id) then
            return true
        end
    end)
    local bloodSpell = common.bloodSpells[bloodSpellKey]
    if (not bloodSpell) then
        return
    end

    local cost = bloodSpell.cost   
    local referenceBlood = blood.getReferenceBloodStatistic(e.caster)

    if (cost <= referenceBlood.current) then
        blood.modReferenceCurrentBloodStatistic(e.caster, cost * -1, true)
        e.castChance = 100
    else
        if (e.caster == tes3.player) then
            e.castChance = 0
            local gmst = tes3.findGMST(tes3.gmst.sMagicSkillFail)
            local oldValue = gmst.value
            gmst.value = common.text.bloodSpellFailed
            timer.delayOneFrame(function() gmst.value = oldValue end, timer.real)
        end
    end
    e.claim = true
end
event.register("spellCast", onSpellCast, {priority = 1e+06})