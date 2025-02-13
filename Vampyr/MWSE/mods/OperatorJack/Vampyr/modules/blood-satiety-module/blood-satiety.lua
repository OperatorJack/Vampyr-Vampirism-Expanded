local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

local bloodSatiety = {}

local levels = {
    [1] = { name = "Desiccated", percentage = 5 },
    [2] = { name = "Torrid", percentage = 20 },
    [3] = { name = "Drained", percentage = 40 },
    [4] = { name = "Thirsty", percentage = 60 },
    [5] = { name = "Uncomfortable", percentage = 80 },
    [6] = { name = "Satisfied", percentage = 90 },
}
function bloodSatiety.getLevelNameFromLevel(level)
    if (levels[math.min(level, 6)]) then
        return levels[math.min(level, 6)].name
    end
    return ""
end

function bloodSatiety.calculateBloodSatiety(reference)
    local bloodStatistic = blood.getReferenceBloodStatistic(reference)
    local percentage = math.round(bloodStatistic.current / bloodStatistic.base * 100)

    for level, config in ipairs(levels) do
        if (config.percentage > percentage) then
            common.logger.trace("Calculated blood satiety of %s for reference %s. Percentage %s, Current %s, Base %s",
                level - 1, reference, percentage, bloodStatistic.current, bloodStatistic.base)

            return math.max(level - 1, 1)
        end
    end

    return 6 -- Max level
end

function bloodSatiety.initializeReferenceData(reference)
    if (reference.data.OJ_VAMPYR.bloodSatiety) then return end

    common.initializeReferenceData(reference)

    local level = bloodSatiety.calculateBloodSatiety(reference)
    reference.data.OJ_VAMPYR.bloodSatiety = {
        current = level
    }
    event.trigger(common.events.bloodSatietyChanged, {
        reference = reference,
        previousSatiety = nil,
        currentSatiety = level
    })
end

function bloodSatiety.getLevel(reference)
    if (common.isReferenceVampire(reference) == false) then return -1 end
    bloodSatiety.initializeReferenceData(reference)
    return reference.data.OJ_VAMPYR.bloodSatiety.current
end

function bloodSatiety.setLevel(reference, level)
    bloodSatiety.initializeReferenceData(reference)
    local previous = reference.data.OJ_VAMPYR.bloodSatiety.current
    local new = level

    if (new ~= previous) then
        reference.data.OJ_VAMPYR.bloodSatiety.current = level
        event.trigger(common.events.bloodSatietyChanged, {
            reference = reference,
            previousSatiety = previous,
            currentSatiety = new
        })
    end
end

return bloodSatiety
