local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

tes3.claimSpellEffectId("restoreBlood", 700)
tes3.claimSpellEffectId("drainBlood", 701)
tes3.claimSpellEffectId("bloodstorm", 702)
tes3.claimSpellEffectId("resistSunDamage", 703)
tes3.claimSpellEffectId("glamour", 704)
tes3.claimSpellEffectId("mistform", 705)

local addBloodstorm = require("OperatorJack.Vampyr.modules.magic-effects.bloodstorm")
local addGlamour = require("OperatorJack.Vampyr.modules.magic-effects.glamour")
local addMistform = require("OperatorJack.Vampyr.modules.magic-effects.mistform")


local function addDrainBlood()
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

local function addRestoreBlood()
	local function restoreBloodTick(e)
		-- Reset feed date for vampire.
		if (e.effectInstance.state == tes3.spellState.beginning) then
			e.effectInstance.target.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
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
		blood.modReferenceCurrentBloodStatistic(e.effectInstance.target, diff, true)
	end

	framework.effects.restoration.createBasicEffect({
		-- Base information.
		id = tes3.effect.restoreBlood,
		name = "Restore Blood",
		description = "Restores blood to vampires, where the amount restored per second is equal to the effect's magnitude.",

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

local function addResistSunDamage()
	local function resistSunDamageTick(e)
		-- Trigger into the spell system.
		if (not e:trigger()) then
			return
		end
	end

	framework.effects.restoration.createBasicEffect({
		-- Base information.
		id = tes3.effect.resistSunDamage,
		name = "Resist Sun Damage",
		description = "Provides resistance against sun damage for vampires, where the percentage resisted is the magnitude of the effect..",

		-- Basic dials.
		baseCost = 2.0,

		-- Various flags.
		allowEnchanting = false,
		allowSpellmaking = false,
		canCastTarget = true,
        canCastTouch = true,
		canCastSelf = true,
		nonRecastable = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = resistSunDamageTick,
	})
end



local function addEffects()
	addRestoreBlood()
	addDrainBlood()
	addBloodstorm()
	addResistSunDamage()
	addGlamour()
	addMistform()
end
event.register("magicEffectsResolved", addEffects)