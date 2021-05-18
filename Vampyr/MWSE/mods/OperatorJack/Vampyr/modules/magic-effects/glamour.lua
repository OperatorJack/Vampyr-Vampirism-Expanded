local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

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

        -- Place fade-out VFX
        local object = tes3.getObject(common.ids.glamour.fadeout)

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

local function addGlamour()
	framework.effects.illusion.createBasicEffect({
		-- Base information.
		id = tes3.effect.glamour,
		name = "Glamour",
		description = "When active, the caster will not be recognized as a vampire.",

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
		onTick = onGlamourTick,
	})
end

return addGlamour