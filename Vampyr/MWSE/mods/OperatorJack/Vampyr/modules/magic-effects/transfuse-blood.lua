local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

tes3.claimSpellEffectId("transfuseBlood", 701)

local function transfuseBloodTick(e)
    local caster = e.sourceInstance.caster

    -- Reset feed date for vampire.
    if (e.effectInstance.state == tes3.spellState.beginning) then
        caster.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
    end

    local target = e.effectInstance.target

    -- Trigger into the spell system.
    local currentBlood = blood.getReferenceBloodStatistic(target).current
    local result, newBlood = e:trigger({
        type = 2,
        value = currentBlood
    })
    if (not result) then
        return
    end

    local diff = newBlood - currentBlood
    blood.modReferenceCurrentBloodStatistic(caster, diff, true)

    common.logger.trace("Caster: %s, Target: %s, Diff: %s", caster, target, diff)

    if common.isReferenceVampire(target) then
        blood.modReferenceCurrentBloodStatistic(target, diff * -1, true)
    else
        tes3.modStatistic({
            reference = target,
            name = "health",
            current = diff * -0.5
        })
    end
end

local function addTransfuseBlood()
	framework.effects.destruction.createBasicEffect({
		-- Base information.
		id = tes3.effect.transfuseBlood,
		name = "Tranfuse Blood",
		description = "Drains blood from the target, where the amount drained per second is equal to the effect's magnitude. If the target is not a vampire, drains health at a lower rate.",
		icon = "OJ\\V\\e\\Tx_S_TrnsfBld.dds",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		canCastTarget = true,
        canCastTouch = true,
		isHarmful = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = transfuseBloodTick,
	})
end

return addTransfuseBlood