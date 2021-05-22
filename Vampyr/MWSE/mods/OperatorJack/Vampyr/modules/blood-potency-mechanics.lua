local common = require("OperatorJack.Vampyr.common")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency")

local function initializedReference(e)
    if (common.isReferenceVampire(e.reference) == false) then return end
    bloodPotency.initializeReferenceData(e.reference)
end
event.register(common.events.initializedReference, initializedReference)

local function playerVampireStateChanged(e)
    if (e.isVampire == true) then
        bloodPotency.initializeReferenceData(tes3.player)
    end
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

local function onBloodChanged(e)
    if (e.statistic ~= "base") then return end

    bloodPotency.setLevel(e.reference, bloodPotency.calculateBloodPotency(e.reference))
end
event.register(common.events.bloodChanged, onBloodChanged)

local function addSpell(ref, spellId)
    mwscript.addSpell{reference = ref, spell = spellId}
end

local function removeSpell(ref, spellId)
    mwscript.removeSpell{reference = ref, spell = spellId}
end

local actions = {
    add = 1,
    remove = 2
}
local ladder = {
    [1] = {
        [common.spells.weakVampiricKiss] = actions.add,
        [common.spells.weakVampiricTouch] = actions.add,
        --[common.bloodSpells.bloodSummonBat.id] = actions.add,
    },
    [2] = {
        [common.spells.lesserVampiricKiss] = actions.add,
        [common.spells.lesserVampiricTouch] = actions.add,
        [common.bloodSpells.mirage.id] = actions.add,
    },
    [3] = {
        [common.spells.vampiricIntuition] = actions.add,
    },
    [4] = {
        [common.spells.vampiricKiss] = actions.add,
        [common.spells.vampiricTouch] = actions.add,
        [common.bloodSpells.mistform.id] = actions.add,
    },
    [5] = {
        [common.bloodSpells.enslave.id] = actions.add,
        --[common.bloodSpells.bloodSummonDaedroth.id] = actions.add,
    },
    [6] = {
        --[common.bloodSpells.bloodboundShortsword.id] = actions.add,
    },
    [7] = {
        [common.bloodSpells.resistSunDamage20.id] = actions.add,
    },
    [8] = {
        [common.bloodSpells.resistSunDamage20.id] = actions.remove,
        [common.bloodSpells.resistSunDamage35.id] = actions.add,
        --[common.bloodSpells.bloodSummonDremora.id] = actions.add,
    },
    [9] = {
        [common.bloodSpells.resistSunDamage35.id] = actions.remove,
        [common.bloodSpells.resistSunDamage50.id] = actions.add,
        --[common.bloodSpells.bloodboundLongsword.id] = actions.add,
        [common.spells.glamour] = actions.add,
    },
    [10] = {
        [common.bloodSpells.resistSunDamage50.id] = actions.remove,
        [common.bloodSpells.immunitySunDamage.id] = actions.add,
        [common.bloodSpells.bloodstorm.id] = actions.add,
        [common.spells.greaterVampiricTouch] = actions.add,
        [common.spells.greaterVampiricKiss] = actions.add,
    }
}

local function onBloodPotencyChanged(e)
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
                addSpell(ref, spellId)
            else
                removeSpell(ref, spellId)
            end
        end
    else
        for spellId in pairs(ladder[e.previousPotency]) do
            if ladder[e.previousPotency][spellId] == actions.add then
                removeSpell(ref, spellId)
            else
                addSpell(ref, spellId)
            end
        end
    end
end
event.register(common.events.bloodPotencyChanged, onBloodPotencyChanged)