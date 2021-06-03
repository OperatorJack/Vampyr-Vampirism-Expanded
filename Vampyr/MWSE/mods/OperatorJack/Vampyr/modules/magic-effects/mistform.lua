local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

tes3.claimSpellEffectId("mistform", 705)

local doors = {}

event.register("objectInvalidated", function(e)
    doors[e.object] = nil
end)

local function resetDoors()
    for door in pairs(doors) do
        if door.position:distance(tes3.player.position) >= 128 then
            door.hasNoCollision = false
            doors[door] = nil
        end
    end
end

local function onTick(e)
    resetDoors()

    for door in common.iterReferencesNearTargetPosition(tes3.player.position, 128, {tes3.objectType.door}) do
        if not door.destination and not doors[door] then
            doors[door] = true
            door.hasNoCollision = true
        end
    end
end

local function appCullNodes(nodes, appCulledState)
    for _, node in ipairs(nodes) do
        if node then
            node.appCulled = appCulledState
        end
    end
end

local localTimer = nil
local function stop()
    resetDoors()
    if localTimer then localTimer:cancel() end
end

local function start()
    stop()

    -- Disable combat controls
    tes3.mobilePlayer.attackDisabled = true
    tes3.mobilePlayer.magicDisabled = true

    -- Start the effect
    tes3.mobilePlayer.mobToMobCollision = false

    appCullNodes(tes3.player.sceneNode.children, true)
    appCullNodes(tes3.player1stPerson.sceneNode.children, true)

    local node = nodeManager.getOrAttachVfx(tes3.player, "OJ_V_MistformVfx", common.paths.mistformStartVfx)
    nodeManager.showNode(node)

    tes3.player.sceneNode:update({controllers=true})

    localTimer = timer.start({duration = .1, iterations = -1, callback = onTick})
end

event.register(common.events.calcSunDamage, function(e)
    if tes3.isAffectedBy({reference = e.reference, effect = tes3.effect.mistform}) == true then
        e.damage = 0
    end
end)


event.register("loaded", function(e)
    if tes3.isAffectedBy({reference = tes3.player, effect = tes3.effect.mistform}) == true then
        start()

        -- Add logic to handle beginning state, for when effect loads before game is ready.
    end
end)

event.register("calcHitChance", function(e)
    if tes3.isAffectedBy({reference = e.target, effect = tes3.effect.mistform}) == true then
        e.hitChance = 0
    end
end)

local initialized = false
local function mistformTick(e)
    if e.effectInstance.state == tes3.spellState.beginning or initialized == false then
        start()
        initialized = true

    elseif e.effectInstance.state == tes3.spellState.working and tes3.mobilePlayer.mobToMobCollision == true then
        tes3.mobilePlayer.mobToMobCollision = false

    elseif e.effectInstance.state == tes3.spellState.ending then
        -- Disable combat controls
        tes3.mobilePlayer.attackDisabled = false
        tes3.mobilePlayer.magicDisabled = false

        -- Kill the effect
        tes3.mobilePlayer.mobToMobCollision = true
        stop()

        initialized = false

        appCullNodes(tes3.player.sceneNode.children, false)
        appCullNodes(tes3.player1stPerson.sceneNode.children, false)

        local node = nodeManager.getOrAttachVfx(e.sourceInstance.caster, "OJ_V_MistformVfx", common.paths.mistformStartVfx)
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
            duration = 5,
            callback = function ()
                if (fadeout) then
                    fadeout:disable()
                    timer.delayOneFrame(function()
                        mwscript.setDelete{ reference = fadeout}
                        fadeout.modified = false
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
	framework.effects.alteration.createBasicEffect({
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
        hasContinuousVFX = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },
        castVFX = common.ids.mistform.cast,
        hitVFX = common.ids.mistform.hit,

		-- Required callbacks.
		onTick = mistformTick,
	})
end

return addMistform