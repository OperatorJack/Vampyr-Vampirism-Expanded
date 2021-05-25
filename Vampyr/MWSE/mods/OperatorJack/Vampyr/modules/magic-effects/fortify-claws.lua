local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

tes3.claimSpellEffectId("fortifyClaws", 707)

event.register(common.events.calcClawModifiers, function(e)
    local magnitude = tes3.getEffectMagnitude({
        reference = e.attackerReference,
        effect = tes3.effect.fortifyClaws
      })

    e.damage = e.damage + magnitude / 10
    e.blood = e.blood + magnitude / 50
    e.chance = e.chance + magnitude / 50
end)

local function addFortifyClaws()
	framework.effects.restoration.createBasicEffect({
		-- Base information.
		id = tes3.effect.fortifyClaws,
		name = "Fortify Claws",
		description = "Fortifies the claws of vampires, sharpening and enhancing their damage. Vampires under this effect will deal more damage and absorb more blood while fighting with claws.",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		canCastSelf = true,
		casterLinked = true,
		nonRecastable = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = function(e) e:trigger() end,
	})
end

return addFortifyClaws