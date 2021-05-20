local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")

tes3.claimSpellEffectId("resistSunDamage", 703)

local function addResistSunDamage()
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
		onTick = function(e) e:trigger() end,
	})
end

return addResistSunDamage