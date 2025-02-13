local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency")

local bloodSpells = {}

function bloodSpells.getBloodSpellConfigurationBySpellId(id)
    local bloodSpellKey = common.getKeyFromValueFunc(common.bloodSpells, function(value)
        if (value.id == id) then
            return true
        end
    end)
    return common.bloodSpells[bloodSpellKey]
end

function bloodSpells.changeSpellFailedMessageBoxForFrame()
    local gmst = tes3.findGMST(tes3.gmst.sMagicSkillFail)
    local oldValue = gmst.value
    gmst.value = common.text.bloodSpellFailed
    timer.delayOneFrame(function() gmst.value = oldValue end, timer.real)
end

function bloodSpells.getBloodMagicCostModifierForPlayer()
    return bloodSpells.getBloodMagicCostModifierForReference(tes3.player)
end

function bloodSpells.getBloodMagicCostModifierForReference(reference)
    local bloodPotencyLevel = bloodPotency.getLevel(reference)
    local modifier = (10 - bloodPotencyLevel) / 11

    return modifier
end

function bloodSpells.isPlayerAbleToCastBloodMagic(cost)
    return bloodSpells.isReferenceAbleToCastBloodMagic(tes3.player, cost)
end

function bloodSpells.isReferenceAbleToCastBloodMagic(reference, cost)
    local cost = cost * bloodSpells.getBloodMagicCostModifierForReference(reference)
    local referenceBlood = blood.getReferenceBloodStatistic(reference)

    if (referenceBlood.current < cost) then
        return false
    else
        return true
    end
end

function bloodSpells.applyBloodMagicCostForPlayer(cost)
    bloodSpells.applyBloodMagicCostForReference(tes3.player, cost)
end

function bloodSpells.applyBloodMagicCostForReference(reference, cost)
    blood.modReferenceCurrentBloodStatistic(reference, cost * -1)

    event.trigger(common.events.bloodMagicCostApplied, {
        reference = reference,
        amount = cost
    })
end

return bloodSpells
