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
                node:getProperty(0x4).maps[1].texture = niSourceTexture.createFromPath(new.path)
            end
        end
    end
end

event.register("loaded", function()
    switchRainTexture(textures.bloodrain, textures.raindrop)
    initialized = false
end)

event.register(common.events.calcSunDamage, function(e)
    if tes3.isAffectedBy({reference = e.reference, effect = tes3.effect.bloodstorm}) == true then
        e.damage = 0
    end
end)

local function startBloodstorm()
    tes3.player.data.OJ_VAMPYR.bloodstorm = {
        previousWeather = tes3.worldController.weatherController.currentWeather.index,
        crimeReported = false
    }

    switchRainTexture(textures.raindrop, textures.bloodrain)

    tes3.worldController.weatherController:switchImmediate(tes3.weather.rain)
    tes3.worldController.weatherController:updateVisuals()
end

local function stopBloodstorm()
    switchRainTexture(textures.bloodrain, textures.raindrop)

    tes3.worldController.weatherController:switchImmediate(tes3.player.data.OJ_VAMPYR.bloodstorm.previousWeather)
    tes3.worldController.weatherController:updateVisuals()

    tes3.player.data.OJ_VAMPYR.bloodstorm = nil
end

local function bloodstormTick(e)
    local caster = e.sourceInstance.caster

    -- Reset feed date for vampire.
    if (e.effectInstance.state == tes3.spellState.beginning or initialized == false) then
        if (caster.cell.isInterior == true) then
            tes3.messageBox("The spell succeeds, but there is no effect indoors.")
            e.effectInstance.state = tes3.spellState.retired
            return
        end

        startBloodstorm()
        initialized = true
    end
    if (e.effectInstance.state == tes3.spellState.working) then
        if (caster.cell.isInterior == true) then
            tes3.messageBox("The spell fails to work indoors.")
            stopBloodstorm()
            e.effectInstance.state = tes3.spellState.retired
            return
        end

        if (tes3.player.data.OJ_VAMPYR.bloodstorm.crimeReported ~= true) then
            local crimeReported = tes3.triggerCrime({
                type = tes3.crimeType.trespass,
                value = 100
            })
            tes3.player.data.OJ_VAMPYR.bloodstorm.crimeReported = crimeReported
        end
    end
    if (e.effectInstance.state == tes3.spellState.ending) then
        stopBloodstorm()
        initialized = false
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