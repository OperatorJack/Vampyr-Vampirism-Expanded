local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

local initialized = false
local function mistformTick(e)
    if (e.effectInstance.state == tes3.spellState.beginning or initialized == false) then
        -- Start the effect
        tes3.mobilePlayer.mobToMobCollision = false
        initialized = true
        local node = nodeManager.getOrAttachVfx(e.sourceInstance.caster, "OJ_V_MistformVfx", common.paths.mistformVfx)
        nodeManager.showNode(node)
    end
    if (e.effectInstance.state == tes3.spellState.ending) then
        -- Kill the effect
        tes3.mobilePlayer.mobToMobCollision = true
        initialized = false
        local node = nodeManager.getOrAttachVfx(e.sourceInstance.caster, "OJ_V_MistformVfx", common.paths.mistformVfx)
        nodeManager.hideNode(node)

        -- Place fade-out VFX
        local object = tes3.getObject(common.ids.mistform.fadeout)

        local fadeout = tes3.createReference({
            object = object,
            position = tes3.player.position,
            cell = tes3.player.cell
        })
        fadeout.modified = false

        timer.start({
            duration = 2,
            callback = function ()
                if (fadeout) then
                    fadeout:disable()
                    timer.delayOneFrame(function()
                        mwscript.setDelete{ reference = fadeout}
                        fadeout = nil
                    end)
                end
            end
        })
    end

    -- Trigger into the spell system.
    if (not e:trigger()) then
        return
    end
end

local function addMistform()
	framework.effects.illusion.createBasicEffect({
		-- Base information.
		id = tes3.effect.mistform,
		name = "Mistform",
		description = "When active, the caster will turn to mist and be able to move through nearby doors and actors.",

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
		onTick = mistformTick,
	})
end

return addMistform