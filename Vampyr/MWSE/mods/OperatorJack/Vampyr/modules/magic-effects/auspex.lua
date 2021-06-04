local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")

tes3.claimSpellEffectId("auspex", 706)

local function addAuspex()
	framework.effects.illusion.createBasicEffect({
		-- Base information.
		id = tes3.effect.auspex,
		name = "Auspex",
		description = "When active, the caster can sense the health, blood, and potency of other beings.",
		icon = "OJ\\V\\e\\Tx_S_Auspex.dds",

		-- Basic dials.
		baseCost = 0,

		-- Various flags.
		canCastSelf = true,
		casterLinked = true,
		hasNoMagnitude = true,
		nonRecastable = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = function(e) e:trigger() end,
	})
end

return addAuspex