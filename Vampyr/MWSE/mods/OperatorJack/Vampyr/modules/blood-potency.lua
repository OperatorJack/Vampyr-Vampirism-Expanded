local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

local bloodPotency = {}

local levels = {
    [-1] = "Mortal",
    [1] = "Newborn",
    [2] = "Fledgling",
    [3] = "Minion",
    [4] = "Servant",
    [5] = "Adept",
    [6] = "Subjugator",
    [7] = "Lord",
    [8] = "Master",
    [9] = "Elder",
    [10] = "Daywalker"
}
function bloodPotency.getLevelNameFromLevel(level)
    return levels[level]
end

function bloodPotency.calculateBloodPotency(reference)
    local baseBlood = blood.getReferenceBloodStatistic(reference).base
    return math.min(1 + math.floor(baseBlood / 50), 10)
end

function bloodPotency.initializeReferenceData(reference)
    if (reference.data.OJ_VAMPYR.bloodPotency) then return end

    local level = bloodPotency.calculateBloodPotency(reference)
    reference.data.OJ_VAMPYR.bloodPotency = {
        current = level
    }
    event.trigger(common.events.bloodPotencyChanged, {
        reference = reference,
        previousPotency = nil,
        currentPotency = level
    })
end

function bloodPotency.getLevel(reference)
    common.initializeReferenceData(reference)
    if (common.isReferenceVampire(reference) == false) then return -1 end

    return reference.data.OJ_VAMPYR.bloodPotency.current
end

function bloodPotency.setLevel(reference, level)
    common.initializeReferenceData(reference)
    local previous = reference.data.OJ_VAMPYR.bloodPotency.current
    local new = level

    if (new ~= previous) then
        reference.data.OJ_VAMPYR.bloodPotency.current = level
        event.trigger(common.events.bloodPotencyChanged, {
            reference = reference,
            previousPotency = previous,
            currentPotency = new
        })
    end
end

return bloodPotency