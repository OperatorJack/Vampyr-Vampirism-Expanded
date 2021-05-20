local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

tes3.claimSpellEffectId("drainBlood", 701)

local function drainBloodTick(e)
    -- Reset feed date for vampire.
    if (e.effectInstance.state == tes3.spellState.beginning) then
        e.sourceInstance.caster.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
    end

    -- Trigger into the spell system.
    local currentBlood = blood.getReferenceBloodStatistic(e.effectInstance.target).current
    local result, newBlood = e:trigger({
        type = 2,
        value = currentBlood
    })
    if (not result) then
        return
    end

    local diff = newBlood - currentBlood
    blood.modReferenceCurrentBloodStatistic(e.sourceInstance.caster, diff, true)

    if common.isReferenceVampire(e.effectInstance.target) then
        blood.modReferenceCurrentBloodStatistic(e.effectInstance.target, diff * -1, true)
    else
        tes3.modStatistic({
            reference = e.effectInstance.target,
            name = "health",
            current = diff * -0.5
        })
    end
end

local function addDrainBlood()
	framework.effects.destruction.createBasicEffect({
		-- Base information.
		id = tes3.effect.drainBlood,
		name = "Drain Blood",
		description = "Drains blood from the target, where the amount drained per second is equal to the effect's magnitude.",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		allowEnchanting = true,
		allowSpellmaking = true,
		canCastTarget = true,
        canCastTouch = true,
		isHarmful = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = drainBloodTick,
	})
end

return addDrainBlood