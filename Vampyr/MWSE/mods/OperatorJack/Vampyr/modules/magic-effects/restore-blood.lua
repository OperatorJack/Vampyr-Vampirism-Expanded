local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

tes3.claimSpellEffectId("restoreBlood", 700)

local function restoreBloodTick(e)
	local target = e.effectInstance.target

    -- Reset feed date for vampire.
    if (e.effectInstance.state == tes3.spellState.beginning) then
        blood.resetLastFeedDay(target)
    end

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

    common.logger.trace("Target: %s, Diff: %s", target, diff)

    blood.modReferenceCurrentBloodStatistic(target, diff, true)
end

local function addRestoreBlood()
	framework.effects.restoration.createBasicEffect({
		-- Base information.
		id = tes3.effect.restoreBlood,
		name = "Restore Blood",
		description = "Restores blood to vampires, where the amount restored per second is equal to the effect's magnitude.",
		icon = "OJ\\V\\e\\Tx_S_RstBld.dds",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		allowEnchanting = true,
		allowSpellmaking = true,
		canCastTarget = true,
        canCastTouch = true,
		canCastSelf = true,
		isHarmful = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = restoreBloodTick,
	})
end

return addRestoreBlood