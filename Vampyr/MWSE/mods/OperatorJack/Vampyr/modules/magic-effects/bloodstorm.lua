local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")

tes3.claimSpellEffectId("bloodstorm", 702)

local function traverse(roots)
    local function iter(nodes)
        for i, node in ipairs(nodes or roots) do
            if node then
                coroutine.yield(node)
                if node.children then
                    iter(node.children)
                end
            end
        end
    end
    return coroutine.wrap(iter)
end

local textures = {
    raindrop = {
        name = common.filenames.bloodrainEffect_raindrop,
        path = common.paths.bloodrainEffect_raindrop
    },
    bloodrain = {
        name = common.filenames.bloodrainEffect_bloodraindrop,
        path = common.paths.bloodrainEffect_bloodraindrop
    }
}

local initialized = false

local function switchRainTexture(current, new)
    for node in traverse{tes3.worldController.weatherController.sceneRainRoot} do
        local success, texture = pcall(function() return node:getProperty(0x4).maps[1].texture end)
        if (success and texture) then
            if (texture.fileName == current.name) then
                common.logger.trace("Setting rain texture path to %s", new.path)
                node:getProperty(0x4).maps[1].texture = niSourceTexture.createFromPath(new.path)
            end
        end
    end
end

event.register(common.events.calcSunDamage, function(e)
    if tes3.isAffectedBy({reference = e.reference, effect = tes3.effect.bloodstorm}) == true then
        e.damage = 0
    end
end)

local actors = {}
event.register("objectInvalidated", function(e)
    actors[e.object] = nil
    common.logger.trace("Actor invalidated. Stopping tracking. Reference: %s", e.object)
end)

local function onTick(e)
    for ref in common.iterReferencesNearTargetPosition(tes3.player.position, 512, {tes3.objectType.npc, tes3.objectType.creature}) do
        common.logger.trace("Iterating Reference: %s", ref)

        if not actors[ref] then
            if ref.object.objectType == tes3.objectType.npc then
                if common.isReferenceVampire(ref) == true then
                    common.logger.trace("Vampire detected. Applying magic source. Reference: %s", ref)
                    tes3.applyMagicSource({
                        reference = ref,
                        name = "Bloodstorm Amplification",
                        effects={{
                            id = tes3.effect.restoreBlood,
                            min = 1,
                            max = 10,
                            duration = 15,
                        }}
                    })
                    actors[ref] = true
                else
                    common.logger.trace("Non-vampire detected. Applying magic source. Reference: %s", ref)
                    tes3.applyMagicSource({
                        reference = ref,
                        name = "Bloodstorm Paranoia",
                        effects={{
                            id = tes3.effect.demoralizeHumanoid,
                            min = math.max(25 - ref.object.level, 0),
                            max = math.max(50 - ref.object.level, 0),
                            duration = 15,
                        }}
                    })
                    ref.mobile:startCombat(tes3.player)
                    timer.delayOneFrame(function()
                        ref.mobile:stopCombat(tes3.player)
                    end)
                    actors[ref] = true
                end
            else
                common.logger.trace("Creature detected. Applying magic source. Reference: %s", ref)
                tes3.applyMagicSource({
                    reference = ref,
                    name = "Bloodstorm Paranoia",
                    effects={{
                        id = tes3.effect.demoralizeCreature,
                        min = math.max(20 - ref.object.level, 0),
                        max = math.max(40 - ref.object.level, 0),
                        duration = 15,
                    }}
                })
                ref.mobile:startCombat(tes3.player)
                timer.delayOneFrame(function()
                    ref.mobile:stopCombat(tes3.player)
                end)
                actors[ref] = true
            end
        end
    end
end

local localTimer = nil
local function stopBloodstorm()
    if localTimer then
        localTimer:cancel()
    end

    switchRainTexture(textures.bloodrain, textures.raindrop)

    tes3.worldController.weatherController:switchImmediate(tes3.player.data.OJ_VAMPYR.bloodstorm.previousWeather)
    tes3.worldController.weatherController:updateVisuals()

    tes3.player.data.OJ_VAMPYR.bloodstorm = nil
end

local function startBloodstorm()
    tes3.player.data.OJ_VAMPYR.bloodstorm = {
        previousWeather = tes3.worldController.weatherController.currentWeather.index,
        crimeReported = false
    }

    switchRainTexture(textures.raindrop, textures.bloodrain)

    tes3.worldController.weatherController:switchImmediate(tes3.weather.rain)
    tes3.worldController.weatherController:updateVisuals()

    if localTimer then
        localTimer:cancel()
    end
    localTimer = timer.start({duration = .1, iterations = -1, callback = onTick})
end

event.register("loaded", function(e)
    switchRainTexture(textures.bloodrain, textures.raindrop)

    if tes3.isAffectedBy({reference = tes3.player, effect = tes3.effect.bloodstorm}) == true then
        startBloodstorm()

        -- Add logic to handle beginning state, for when effect loads before game is ready.
    end
end)

local function bloodstormTick(e)
    local caster = e.sourceInstance.caster

    -- Reset feed date for vampire.
    if (e.effectInstance.state == tes3.spellState.beginning or initialized == false) then
        if (caster.cell.isInterior == true) then
            common.logger.trace("Attempted to cast indoors. Retiring effect.")
            tes3.messageBox("The spell succeeds, but there is no effect indoors.")
            e.effectInstance.state = tes3.spellState.retired
            return
        end

        startBloodstorm()
        initialized = true
        common.logger.trace("Initializing effect.")

    end
    if (e.effectInstance.state == tes3.spellState.working) then
        if (tes3.player.cell.isInterior == true) then
            tes3.messageBox("The spell fails to work indoors.")
            stopBloodstorm()
            e.effectInstance.state = tes3.spellState.retired
            common.logger.trace("Entered indoors - retiring effect.")
            return
        end

        if (tes3.player.data.OJ_VAMPYR.bloodstorm.crimeReported ~= true) then
            local crimeReported = tes3.triggerCrime({
                type = tes3.crimeType.trespass,
                value = 100
            })
            tes3.player.data.OJ_VAMPYR.bloodstorm.crimeReported = crimeReported
            common.logger.trace("Crime reported. Disabling future reports for current effect.")
        end
    end
    if (e.effectInstance.state == tes3.spellState.ending) then
        stopBloodstorm()
        initialized = false
        common.logger.trace("Ending effect.")
    end

    -- Trigger into the spell system.
    if (not e:trigger()) then
        return
    end
end

local function addBloodstorm()
	framework.effects.alteration.createBasicEffect({
		-- Base information.
		id = tes3.effect.bloodstorm,
		name = "Bloodstorm",
		description = "Creates a bloodstorm for the duration of the spell, which rains blood and boosts the abilities of vampires within it.",
		icon = "OJ\\V\\e\\Tx_S_BldStrm.dds",

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
		onTick = bloodstormTick,
	})
end

return addBloodstorm