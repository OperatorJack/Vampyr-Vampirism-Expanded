local common = require("OperatorJack.Vampyr.common")

local feeding = require("OperatorJack.Vampyr.modules.combat.feeding")
local embrace = require("OperatorJack.Vampyr.modules.functions.embrace")
local enthrall = require("OperatorJack.Vampyr.modules.functions.enthrall")
local bloodExtraction = require("OperatorJack.Vampyr.modules.functions.blood-extraction")

---@param e dialogueEnvironmentCreatedEventData
local function onDialogueEnvironmentCreated(e)
    -- Cache the environment variables outside the function for easier access.
    -- Dialogue scripters shouldn't have to constantly pass these to the functions anyway.

    local env = e.environment
    local reference = env.reference
    local dialogue = env.dialogue
    local info = env.info

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrBloodExtractionTarget(serumId)
        common.logger.debug("Triggering blood extraction for reference: %s; Dialogue/INFO: %s/%s; Into Empty Vial %s",
            reference, dialogue, info.id, serumId)

        bloodExtraction.applyBloodExtractionToReference({ source = tes3.player, target = reference, serumId = serumId })
    end

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrBloodExtractionPlayer(serumId)
        common.logger.debug("Triggering blood extraction for reference: %s; Dialogue/INFO: %s/%s; Into Empty Vial %s",
            reference, dialogue, info.id, serumId)

        bloodExtraction.applyBloodExtractionToReference({ source = reference, target = tes3.player, serumId = serumId })
    end

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrFeed()
        common.logger.debug("Triggering feed on for reference: %s; Dialogue/INFO: %s/%s;", reference, dialogue, info.id)

        feeding.enterFeedMode({
            target = reference,
            hostile = false
        })
    end

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrEnthrall()
        common.logger.debug("Triggering enthrall on for reference: %s; Dialogue/INFO: %s/%s;", reference, dialogue,
            info.id)

        enthrall.enthrall(reference)
    end

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrEmbraceTarget()
        common.logger.debug("Triggering embrace on for reference: %s; Dialogue/INFO: %s/%s;", reference, dialogue,
            info.id)

        embrace.embraceTarget(reference)
    end

    ---@diagnostic disable-next-line: inject-field
    function env.vampyrEmbracePlayer()
        common.logger.debug("Triggering embrace on for reference: %s; Dialogue/INFO: %s/%s;", reference, dialogue,
            info.id)

        embrace.embraceByTarget(reference)
    end
end
event.register(tes3.event.dialogueEnvironmentCreated, onDialogueEnvironmentCreated)
