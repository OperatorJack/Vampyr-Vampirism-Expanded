local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

tes3.claimSpellEffectId("fortifyClaws", 707)

event.register(common.events.calcClawDamage, function(e)
    local magnitude = tes3.getEffectMagnitude({
        reference = e.attackerReference,
        effect = tes3.effect.fortifyClaws
      })

    e.damage = e.damage + magnitude / 10
end)

event.register(common.events.calcClawBloodDraw, function(e)
    local magnitude = tes3.getEffectMagnitude({
        reference = e.attackerReference,
        effect = tes3.effect.fortifyClaws
      })

    e.blood = e.blood + magnitude / 50
    e.bloodChance = e.bloodChance + magnitude / 25
end)

local function addFortifyClaws()
	framework.effects.alteration.createBasicEffect({
		-- Base information.
		id = tes3.effect.fortifyClaws,
		name = "Fortify Claws",
		description = "Fortifies the claws of vampires, sharpening and enhancing their damage. Vampires under this effect will deal more damage and absorb more blood while fighting with claws.",
		icon = "OJ\\V\\e\\Tx_S_FtfyClws.dds",

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