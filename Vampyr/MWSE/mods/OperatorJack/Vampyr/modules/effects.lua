local framework = require("OperatorJack.MagickaExpanded.magickaExpanded")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

tes3.claimSpellEffectId("restoreBlood", 700)
tes3.claimSpellEffectId("drainBlood", 701)
tes3.claimSpellEffectId("bloodstorm", 702)
tes3.claimSpellEffectId("resistSunDamage", 703)
tes3.claimSpellEffectId("glamour", 704)
tes3.claimSpellEffectId("mistform", 705)

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

local function addDrainBlood()
	local function drainBloodTick(e)
		-- Reset feed date for vampire.
		if (e.effectInstance.state == tes3.spellState.beginning) then
			e.sourceInstance.caster.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
		end

		-- Trigger into the spell system.
		local currentBlood = blood.getReferenceBloodStatistic(e.effectInstance.target).current
		local result, newBlood = e:trigger({
			type = 2,
			value = currentBlood
		})
		if (not result) then
			return
		end

		local diff = newBlood - currentBlood
		blood.modReferenceCurrentBloodStatistic(e.sourceInstance.caster, diff, true)

		if common.isReferenceVampire(e.effectInstance.target) then
			blood.modReferenceCurrentBloodStatistic(e.effectInstance.target, diff * -1, true)
		else
			tes3.modStatistic({
				reference = e.effectInstance.target,
				name = "health",
				current = diff * -0.5
			})
		end
	end

	framework.effects.destruction.createBasicEffect({
		-- Base information.
		id = tes3.effect.drainBlood,
		name = "Drain Blood",
		description = "Drains blood from the target, where the amount drained per second is equal to the effect's magnitude.",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		allowEnchanting = true,
		allowSpellmaking = true,
		canCastTarget = true,
        canCastTouch = true,
		isHarmful = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = drainBloodTick,
	})
end

local function addRestoreBlood()
	local function restoreBloodTick(e)
		-- Reset feed date for vampire.
		if (e.effectInstance.state == tes3.spellState.beginning) then
			e.effectInstance.target.data.OJ_VAMPYR.lastFeedDay = tes3.worldController.daysPassed.value
		end

		-- Trigger into the spell system.
		local currentBlood = blood.getReferenceBloodStatistic(e.effectInstance.target).current
		local result, newBlood = e:trigger({
			type = 2,
			value = currentBlood
		})
		if (not result) then
			return
		end

		local diff = newBlood - currentBlood
		blood.modReferenceCurrentBloodStatistic(e.effectInstance.target, diff, true)
	end

	framework.effects.restoration.createBasicEffect({
		-- Base information.
		id = tes3.effect.restoreBlood,
		name = "Restore Blood",
		description = "Restores blood to vampires, where the amount restored per second is equal to the effect's magnitude.",

		-- Basic dials.
		baseCost = 5.0,

		-- Various flags.
		allowEnchanting = true,
		allowSpellmaking = true,
		canCastTarget = true,
        canCastTouch = true,
		canCastSelf = true,
		isHarmful = true,

		-- Graphics/sounds.
		lighting = { 0.99, 0.95, 0.67 },

		-- Required callbacks.
		onTick = restoreBloodTick,
	})
end

local function addBloodstorm()
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

	framework.effects.alteration.createBasicEffect({
		-- Base information.
		id = tes3.effect.bloodstorm,
		name = "Bloodstorm",
		description = "Creates a bloodstorm for the duration of the spell, which rains blood and boosts the abilities of vampires within it.",

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

local function addResistSunDamage()
	local function resistSunDamageTick(e)
		-- Trigger into the spell system.
		if (not e:trigger()) then
			return
		end
	end

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
		onTick = resistSunDamageTick,
	})
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
		onTick = function(e) e:trigger() end,
	})
end

local function addMistform()
	local vfxNode

	local function getOrAttachVfx(reference)
		local node, sceneNode
		sceneNode = reference.sceneNode
		node = sceneNode:getObjectByName("OJ_V_MistformVfx")

		if (not node) then
			vfxNode = vfxNode or tes3.loadMesh(common.paths.mistformVfx)
			node = vfxNode:clone()

			if (reference.object.race) then
				if (reference.object.race.weight and reference.object.race.height) then
				local weight = reference.object.race.weight.male
				local height = reference.object.race.height.male
				if (reference.object.female == true) then
					weight = reference.object.race.weight.female
					height = reference.object.race.height.female
				end

				local weightMod = 1 / weight
				local heightMod = 1/ height

				local r = node.rotation
				local s = tes3vector3.new(weightMod, weightMod, heightMod)
				node.rotation = tes3matrix33.new(r.x * s, r.y * s, r.z * s)
				end
			end

			sceneNode:attachChild(node, true)
			sceneNode:update()
			sceneNode:updateNodeEffects()
		end

		return node
	end

	local function showNode(node)
		if (node.appCulled == true) then
			node.appCulled = false
		end
	end

	local function hideNode(node)
		if (node.appCulled == false) then
			node.appCulled = true
		end
	end

	local initialized = false
	local function mistformTick(e)
		if (e.effectInstance.state == tes3.spellState.beginning or initialized == false) then
			-- Start the effect
			tes3.mobilePlayer.mobToMobCollision = false
			initialized = true
			local node = getOrAttachVfx(e.sourceInstance.caster)
			showNode(node)
		end
		if (e.effectInstance.state == tes3.spellState.ending) then
			-- Kill the effect
			tes3.mobilePlayer.mobToMobCollision = true
			initialized = false
			local node = getOrAttachVfx(e.sourceInstance.caster)
        	hideNode(node)
		end

		-- Trigger into the spell system.
		if (not e:trigger()) then
			return
		end
	end

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

local function addEffects()
	addRestoreBlood()
	addDrainBlood()
	addBloodstorm()
	addResistSunDamage()
	addGlamour()
	addMistform()
end
event.register("magicEffectsResolved", addEffects)