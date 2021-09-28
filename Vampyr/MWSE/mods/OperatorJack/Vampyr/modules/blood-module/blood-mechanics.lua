--[[
    Adds mechanics around the blood mechanic.

    - Initializes blood values when the player becomes a vampire, or a reference is initialized.
]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

local function initializeBlood(reference)
    if (common.isReferenceVampire(reference) == false) then return end

    local baseBlood = blood.getPlayerStartingBaseBlood()
    if (reference ~= tes3.player) then
        baseBlood = blood.getNpcStartingBaseBlood(reference.mobile)
    end

    reference.data.OJ_VAMPYR.blood = {
        base = baseBlood,
        current = 1,
    }


    if (reference ~= tes3.player) then
        reference.data.OJ_VAMPYR.blood.current = math.random(1, baseBlood)
    else
        -- Magic fixup for UI syncing issues, due to simple vampire state not recalculating UI values.
        blood.modPlayerBaseBloodStatistic(0)
        reference.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
    end

    reference.data.OJ_VAMPYR.bloodInitialized = true
end

local function initializedReference(e)
    initializeBlood(e.reference)
end
event.register(common.events.initializedReference, initializedReference )

local function playerVampireStateChanged(e)
    if (e.isVampire == true) then
        initializeBlood(tes3.player)
    end
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)


local function updateDaysPassedSinceLastFeed()
    if (tes3.player.data.OJ_VAMPYR.isVampire == true) then
        -- Check Blood modification based on last feed day.
        local daysPassed = tes3.worldController.daysPassed.value - tes3.player.data.OJ_VAMPYR.lastFeedDay
        if (daysPassed > 0) then
            local modAmount = -1 * (1.2 ^ daysPassed) - 20
            blood.modPlayerCurrentBloodStatistic(modAmount)
            if (blood.getPlayerBloodStatistic().current <= 0) then
                blood.modPlayerBaseBloodStatistic(-1)
                tes3.mobilePlayer:applyHealthDamage(1)
            end
        end
    end
end
event.register(common.events.secondPassed, updateDaysPassedSinceLastFeed)