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

local function onBloodPotencyChanged(e)
    local ref = e.reference
    local increased = true
    if (e.previousPotency) then 
        if (e.previousPotency > e.currentPotency) then
            increased = false
        end 
    end

    if (increased == true) then
        if (e.currentPotency == 1) then
            addSpell(ref, common.spells.weakVampiricKiss)
            addSpell(ref, common.spells.weakVampiricTouch)
            addSpell(ref, common.bloodSpells.bloodSummonBat)
        elseif (e.currentPotency == 2) then
            addSpell(ref, common.spells.lesserVampiricKiss)
            addSpell(ref, common.spells.lesserVampiricTouch)
            addSpell(ref, common.bloodSpells.mirage)
        elseif (e.currentPotency == 3) then
            addSpell(ref, common.bloodSpells.bloodboundDagger)
        elseif (e.currentPotency == 4) then
            addSpell(ref, common.spells.vampiricKiss)
            addSpell(ref, common.spells.vampiricTouch)
            addSpell(ref, common.bloodSpells.mistform)
        elseif (e.currentPotency == 5) then
            addSpell(ref, common.bloodSpells.enslave)
            addSpell(ref, common.bloodSpells.bloodSummonDaedroth)
        elseif (e.currentPotency == 6) then
            addSpell(ref, common.bloodSpells.bloodboundShortsword)
        elseif (e.currentPotency == 7) then
            addSpell(ref, common.bloodSpells.resistSunDamage20)
        elseif (e.currentPotency == 8) then
            removeSpell(ref, common.bloodSpells.resistSunDamage20)
            addSpell(ref, common.bloodSpells.resistSunDamage35)
            addSpell(ref, common.bloodSpells.bloodSummonDremora)
        elseif (e.currentPotency == 9) then
            removeSpell(ref, common.bloodSpells.resistSunDamage35)
            addSpell(ref, common.bloodSpells.resistSunDamage50)
            addSpell(ref, common.bloodSpells.bloodboundLongsword)
            addSpell(ref, common.spells.glamour)
        elseif (e.currentPotency == 10) then
            removeSpell(ref, common.bloodSpells.resistSunDamage50)
            addSpell(ref, common.spells.greaterVampiricTouch)
            addSpell(ref, common.spells.greaterVampiricKiss)
            addSpell(ref, common.bloodSpells.immunitySunDamage)
            addSpell(ref, common.bloodSpells.bloodstorm)
        end
    else
        if (e.previousPotency == 1) then
            removeSpell(ref, common.spells.weakVampiricKiss)
            removeSpell(ref, common.spells.weakVampiricTouch)
            removeSpell(ref, common.bloodSpells.bloodSummonBat)
        elseif (e.previousPotency == 2) then
            removeSpell(ref, common.spells.lesserVampiricKiss)
            removeSpell(ref, common.spells.lesserVampiricTouch)
            removeSpell(ref, common.bloodSpells.mirage)
        elseif (e.previousPotency == 3) then
            removeSpell(ref, common.bloodSpells.bloodboundDagger)
        elseif (e.previousPotency == 4) then
            removeSpell(ref, common.spells.vampiricKiss)
            removeSpell(ref, common.spells.vampiricTouch)
            removeSpell(ref, common.bloodSpells.mistform)
        elseif (e.previousPotency == 5) then
            removeSpell(ref, common.bloodSpells.enslave)
            removeSpell(ref, common.bloodSpells.bloodSummonDaedroth)
        elseif (e.previousPotency == 6) then
            removeSpell(ref, common.bloodSpells.bloodboundShortsword)
        elseif (e.previousPotency == 7) then
            removeSpell(ref, common.bloodSpells.resistSunDamage20)
        elseif (e.previousPotency == 8) then
            addSpell(ref, common.bloodSpells.resistSunDamage20)
            removeSpell(ref, common.bloodSpells.resistSunDamage35)
            removeSpell(ref, common.bloodSpells.bloodSummonDremora)
        elseif (e.previousPotency == 9) then
            addSpell(ref, common.bloodSpells.resistSunDamage35)
            removeSpell(ref, common.bloodSpells.resistSunDamage50)
            removeSpell(ref, common.bloodSpells.bloodboundLongsword)
            removeSpell(ref, common.spells.glamour)
        elseif (e.previousPotency == 10) then
            addSpell(ref, common.bloodSpells.resistSunDamage50)
            removeSpell(ref, common.spells.greaterVampiricTouch)
            removeSpell(ref, common.spells.greaterVampiricKiss)
            removeSpell(ref, common.bloodSpells.immunitySunDamage)
            removeSpell(ref, common.bloodSpells.bloodstorm)
        end
    end
end
event.register(common.events.bloodPotencyChanged, onBloodPotencyChanged)