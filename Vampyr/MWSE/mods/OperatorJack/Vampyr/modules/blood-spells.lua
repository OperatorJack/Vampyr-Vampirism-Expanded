local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency")

local bloodSpells = {}

function bloodSpells.getBloodMagicCostModifierForPlayer()
    return bloodSpells.getBloodPotencyCostModifierForReference(tes3.player)
end

function bloodSpells.getBloodMagicCostModifierForReference(reference)
    local bloodPotencyLevel = bloodPotency.getLevel(reference)
    local modifier = (10 - bloodPotencyLevel) / 11
    
    return modifier
end

function bloodSpells.applyBloodMagicCostForPlayer(cost)
    bloodSpells.applyBloodCostForBloodMagicForReference(tes3.player, cost)
end

function bloodSpells.applyBloodMagicCostForReference(reference, cost)
    blood.modReferenceCurrentBloodStatistic(reference, cost * -1)

    event.trigger(common.events.bloodMagicCostApplied, {
        reference = reference,
        amount = cost
    })
end

return bloodSpells