local common = require("OperatorJack.Vampyr.common")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency")

local function onBloodChanged(e)
    if (e.statistic ~= "base") then return end

    bloodPotency.setLevel(e.reference, bloodPotency.calculateBloodPotency(e.reference))
end
event.register(common.events.bloodChanged, onBloodChanged)

local actions = {
    add = 1,
    remove = 2
}
local ladder = {
    [1] = {
        [common.spells.weakVampiricKiss] = actions.add,
        [common.spells.weakVampiricTouch] = actions.add,
    },
    [2] = {
        [common.bloodSpells.mirage.id] = actions.add,
    },
    [3] = {
        [common.spells.weakVampiricKiss] = actions.remove,
        [common.spells.weakVampiricTouch] = actions.remove,

        [common.spells.lesserVampiricKiss] = actions.add,
        [common.spells.lesserVampiricTouch] = actions.add,
        [common.spells.vampiricIntuition] = actions.add,
    },
    [4] = {
        [common.bloodSpells.mistform.id] = actions.add,
    },
    [5] = {
        [common.spells.lesserVampiricKiss] = actions.remove,
        [common.spells.lesserVampiricTouch] = actions.remove,

        [common.spells.vampiricTouch] = actions.add,
        [common.spells.vampiricKiss] = actions.add,
    },
    [6] = {
        [common.bloodSpells.enslave.id] = actions.add,
        [common.spells.transfusion] = actions.add,
    },
    [7] = {
        [common.bloodSpells.resistSunDamage20.id] = actions.add,
    },
    [8] = {
        [common.bloodSpells.resistSunDamage20.id] = actions.remove,
        [common.spells.vampiricTouch] = actions.remove,
        [common.spells.vampiricKiss] = actions.remove,

        [common.bloodSpells.resistSunDamage35.id] = actions.add,
        [common.spells.greaterVampiricTouch] = actions.add,
        [common.spells.greaterVampiricKiss] = actions.add,
    },
    [9] = {
        [common.bloodSpells.resistSunDamage35.id] = actions.remove,

        [common.bloodSpells.resistSunDamage50.id] = actions.add,
        [common.spells.glamour] = actions.add,
    },
    [10] = {
        [common.bloodSpells.resistSunDamage50.id] = actions.remove,

        [common.bloodSpells.immunitySunDamage.id] = actions.add,
        [common.bloodSpells.bloodstorm.id] = actions.add,
    }
}

event.register(common.events.bloodPotencyChanged, function(e)
    local ref = e.reference
    local increased = true
    if (e.previousPotency) then
        if (e.previousPotency > e.currentPotency) then
            increased = false
        end
    end

    if increased == true then
        for spellId in pairs(ladder[e.currentPotency]) do
            if ladder[e.currentPotency][spellId] == actions.add then
                tes3.addSpell({ reference = ref, spell = spellId })
            else
                tes3.removeSpell({ reference = ref, spell = spellId })
            end
        end
    else
        for spellId in pairs(ladder[e.previousPotency]) do
            if ladder[e.previousPotency][spellId] == actions.add then
                tes3.removeSpell({ reference = ref, spell = spellId })
            else
                tes3.addSpell({ reference = ref, spell = spellId })
            end
        end
    end
end)

-- Higher blood level is more effective at feeding.
event.register(common.events.calcBloodFeedingChance, function(e)
    local level = bloodPotency.getLevel(e.reference)
    e.chance = e.chance * level
end)
