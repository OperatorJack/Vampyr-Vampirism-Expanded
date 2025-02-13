--[[
    This module handles the blood mechanic, including functions to get, set, and mod player or other actor blood levels.

    -
]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")

local blood = {}
-- [[ Blood - Common Functions ]] --
function blood.calculateFeedBlood(mobile)
    local current = mobile.health.current - (mobile.endurance.current / 10) - (mobile.willpower.current / 10)
    local base = mobile.health.base - (mobile.endurance.base / 10) - (mobile.willpower.base / 10)
    return current, base
end

function blood.getNpcStartingBaseBlood(mobile)
    local endurance = mobile.endurance.base
    local willpower = mobile.willpower.base
    local health = mobile.health.base
    return health + (endurance / 10) + (willpower / 10)
end

function blood.getPlayerStartingBaseBlood()
    return 30
end

function blood.isInitialized(reference)
    if (reference.data.OJ_VAMPYR) then
        return reference.data.OJ_VAMPYR.bloodInitialized == true
    end
    return false
end

function blood.resetLastFeedDay(reference)
    reference.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
end

function blood.applyFeedingAction(reference, amount)
    local chance = 10
    local payload = {
        reference = reference,
        chance = chance
    }
    event.trigger(common.events.calcBloodFeedingChance, payload)
    chance = payload.chance

    if not common.roll(chance) then return 0 end
    common.logger.trace("Applying feeding action to %s. Amount %s.", reference, amount)

    -- If current blood is less than base, refill current blood first.
    -- If current blood is full, increase base blood.
    if reference.data.OJ_VAMPYR.blood.current < reference.data.OJ_VAMPYR.blood.base then
        blood.modReferenceCurrentBloodStatistic(reference, amount)
    else
        blood.modReferenceBaseBloodStatistic(reference, amount)
    end

    blood.resetLastFeedDay(reference)
    return amount
end

--[[ MOD Blood ]]  --
function blood.modReferenceBaseBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    local oldBlood = reference.data.OJ_VAMPYR.blood.base
    local currentBlood = math.max(reference.data.OJ_VAMPYR.blood.base + amount, 0)
    reference.data.OJ_VAMPYR.blood.base = currentBlood

    common.logger.trace("Modding Base Blood for %s. Amount: %s, Old: %s, New: %s.", reference, amount, oldBlood,
        currentBlood)

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "mod",
        statistic = "base",
        amount = amount
    })

    -- Reset current blood to not exceed base blood.
    if reference.data.OJ_VAMPYR.blood.current > reference.data.OJ_VAMPYR.blood.base then
        oldBlood = reference.data.OJ_VAMPYR.blood.base
        currentBlood = reference.data.OJ_VAMPYR.blood.current
        amount = currentBlood - oldBlood

        reference.data.OJ_VAMPYR.blood.current = reference.data.OJ_VAMPYR.blood.base

        common.logger.trace("Modding Current Blood for %s to settle base blood reduction. Amount: %s, Old: %s, New: %s.",
            reference, amount, oldBlood, currentBlood)

        event.trigger(common.events.bloodChanged, {
            reference = reference,
            type = "mod",
            statistic = "current",
            amount = amount
        })
    end
end

function blood.modReferenceCurrentBloodStatistic(reference, amount, isCapped)
    common.initializeReferenceData(reference)
    local currentBlood = reference.data.OJ_VAMPYR.blood.current
    local oldBlood = currentBlood

    if not isCapped then isCapped = true end

    if (amount < 0) then
        currentBlood = math.max(currentBlood + amount, 0)
    end

    if (isCapped == true and amount > 0) then
        currentBlood = math.min(currentBlood + amount, reference.data.OJ_VAMPYR.blood.base)
    elseif (not isCapped or isCapped == false and amount > 0) then
        currentBlood = currentBlood + amount
    end

    reference.data.OJ_VAMPYR.blood.current = currentBlood

    local appliedAmount = currentBlood - oldBlood

    common.logger.trace("Modding Current Blood for %s. Capped: %s, Amount: %s, Applied: %s, Old: %s, New: %s.", reference,
        isCapped, amount, appliedAmount, oldBlood, currentBlood)

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "mod",
        statistic = "current",
        amount = appliedAmount
    })
end

function blood.modPlayerBaseBloodStatistic(amount)
    blood.modReferenceBaseBloodStatistic(tes3.player, amount)
end

function blood.modPlayerCurrentBloodStatistic(amount, isCapped)
    blood.modReferenceCurrentBloodStatistic(tes3.player, amount, isCapped)
end

--[[ SET Blood ]]  --
function blood.setReferenceBaseBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    local oldBlood = reference.data.OJ_VAMPYR.blood.base
    reference.data.OJ_VAMPYR.blood.base = amount

    common.logger.trace("Setting Base Blood for %s. Old: %s, New: %s.", reference, oldBlood, amount)

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "set",
        statistic = "base",
        amount = amount
    })
end

function blood.setReferenceCurrentBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    local oldBlood = reference.data.OJ_VAMPYR.blood.current
    reference.data.OJ_VAMPYR.blood.current = amount

    common.logger.trace("Setting Current Blood for %s. Old: %s, New: %s.", reference, oldBlood, amount)

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "set",
        statistic = "current",
        amount = amount
    })
end

function blood.setPlayerBaseBloodStatistic(amount)
    blood.setReferenceBaseBloodStatistic(tes3.player, amount)
end

function blood.setPlayerCurrentBloodStatistic(amount)
    blood.setReferenceCurrentBloodStatistic(tes3.player, amount)
end

--[[ GET Blood ]]  --
function blood.getReferenceBloodStatistic(reference)
    common.initializeReferenceData(reference)
    return reference.data.OJ_VAMPYR.blood
end

function blood.getPlayerBloodStatistic()
    return blood.getReferenceBloodStatistic(tes3.player)
end

return blood
