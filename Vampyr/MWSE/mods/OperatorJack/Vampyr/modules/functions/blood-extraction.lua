local common = require("OperatorJack.Vampyr.common")

local exports = {}
local serums = {}
exports.registerSerum = function(params)
    local serumId = params.serumId
    local emptySerumId = params.emptySerumId
    local applyHealthDamage = params.applyHealthDamage
    serums[serumId] = {
        emptySerumId = emptySerumId,
        applyHealthDamage = applyHealthDamage
    }
end

exports.bloodExtractionTarget = function(reference, serumId)
    -- Begins the process of extracting blood from a reference

    -- @TODO: Implement
end

exports.vampyrBloodExtractionPlayer = function(reference, serumId)
    -- Begins the process of extracting blood from from the player, for a reference.

    -- @TODO: Implement
end

return exports
