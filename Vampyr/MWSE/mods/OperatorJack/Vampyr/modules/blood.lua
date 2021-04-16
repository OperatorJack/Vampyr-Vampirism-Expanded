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

 --[[ MOD Blood ]] --
function blood.modReferenceBaseBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    reference.data.OJ_VAMPYR.blood.base = math.max(reference.data.OJ_VAMPYR.blood.base + amount, 0)

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "mod",
        statistic = "base",
        amount = amount
    })
end
function blood.modReferenceCurrentBloodStatistic(reference, amount, isCapped)
    common.initializeReferenceData(reference)
    local currentBlood = reference.data.OJ_VAMPYR.blood.current
    local pastBlood = currentBlood

    if (amount < 0) then
        currentBlood = math.max(currentBlood + amount, 0)
    end

    if (isCapped == true and amount > 0) then
        currentBlood = math.min(currentBlood + amount, reference.data.OJ_VAMPYR.blood.base)
    elseif (isCapped == false and amount > 0) then
        currentBlood = currentBlood + amount
    end

    reference.data.OJ_VAMPYR.blood.current = currentBlood

    local appliedAmount = currentBlood - pastBlood
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

 --[[ SET Blood ]] --
function blood.setReferenceBaseBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    reference.data.OJ_VAMPYR.blood.base = amount

    event.trigger(common.events.bloodChanged, {
        reference = reference,
        type = "set",
        statistic = "base",
        amount = amount
    })
end
function blood.setReferenceCurrentBloodStatistic(reference, amount)
    common.initializeReferenceData(reference)
    reference.data.OJ_VAMPYR.blood.current = amount

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

 --[[ GET Blood ]] --
function blood.getReferenceBloodStatistic(reference)
    common.initializeReferenceData(reference)
    return reference.data.OJ_VAMPYR.blood
end

function blood.getPlayerBloodStatistic()
    return blood.getReferenceBloodStatistic(tes3.player)
end

return blood