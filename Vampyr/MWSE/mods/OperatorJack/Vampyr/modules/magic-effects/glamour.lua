local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

tes3.claimSpellEffectId("glamour", 704)

event.register(common.events.dialogueFilterPcVampire, function(e)
    if e.isVampire == false then return end

    local isVampire = tes3.isAffectedBy({
        reference = tes3.player,
        effect = tes3.effect.glamour
      }) == false

    e.isVampire = isVampire
end)

local initialized = false
local function onGlamourTick(e)
    if (e.effectInstance.state == tes3.spellState.beginning or initialized == false) then
        initialized = true

        local node = nodeManager.getOrAttachVfx(e.sourceInstance.caster, "OJ_V_GlamourVfx", common.paths.glamourVfx)
        nodeManager.showNode(node)
    end
    if (e.effectInstance.state == tes3.spellState.ending) then
        -- Kill the effect
        initialized = false

        local node = nodeManager.getOrAttachVfx(e.sourceInstance.caster, "OJ_V_GlamourVfx", common.paths.glamourVfx)
        nodeManager.hideNode(node)
    end

    -- Trigger into the spell system.
    if (not e:trigger()) then
        return
    end
end

local function addGlamour()
	framework.effects.illusion.createBasicEffect({
		-- Base information.
		id = tes3.effect.glamour,
		name = "Glamour",
		description = "When active, the caster will not be recognized as a vampire.",
		icon = "OJ\\V\\e\\Tx_S_Glamour.dds",

		-- Basic dials.
		baseCost = 0,

		-- Various flags.
		canCastSelf = true,
		casterLinked = true,
		hasNoMagnitude = true,
		nonRecastable = true,

		-- Graphics/sounds.
		particleTexture = "vampyr\\kurp\\blank.dds",
		lighting = { 0.99, 0.95, 0.67 },
        castVFX = common.ids.glamour.cast,
        hitVFX = common.ids.glamour.hit,

		-- Required callbacks.
		onTick = onGlamourTick,
	})
end

return addGlamour