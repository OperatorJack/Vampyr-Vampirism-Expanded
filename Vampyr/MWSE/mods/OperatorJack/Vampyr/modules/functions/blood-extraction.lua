local common = require("OperatorJack.Vampyr.common")

---@class Vampyr.BloodExtraction
local this = {}

local serums = {}

---@class Vampyr.BloodExtraction.serum
---@field serumId string  The Object ID of the serum.
---@field emptySerumId string  The Object ID of the empty vial of the serum.
---@field applyHealthDamage number  The amount of damage to apply when blood is extracted into the serum.

---Registers an object as a serum.
---@param params Vampyr.BloodExtraction.serum
this.registerSerum = function(params)
    local serumId = params.serumId
    local emptySerumId = params.emptySerumId
    local applyHealthDamage = params.applyHealthDamage
    serums[serumId] = {
        emptySerumId = emptySerumId,
        applyHealthDamage = applyHealthDamage
    }
end

---@class Vampyr.BloodExtraction.applyBloodExtractionParams
---@field serumId string  The Object ID of the serum.
---@field source tes3reference  The reference performing the blood extraction and receiving the resulting vial.
---@field target tes3reference  The reference being extracted from.

---Applys the blood extraction process between the `source` reference, the one performing the blood extraction action, to the `target` reference, the one being extracted from.
---@param params Vampyr.BloodExtraction.applyBloodExtractionParams
this.applyBloodExtractionToReference = function(params)
    -- Begins the process of extracting blood from a reference, for another reference.

    -- @TODO: Implement
end

return this
