local common = require("OperatorJack.Vampyr.common")

local functions = {}

local stencil = nil
local stencilArmsAndLegs = nil

local stenciledActors = {}
local vanillaStencilProperties = {}
local vanillaStencilObjects = {
    ["Left Upper Leg"] = true,
    ["Left Ankle"] = true,
    ["Left Knee"] = true,
    ["Left Upper Arm"] = true,
    ["Left Forearm"] = true,
    ["Left Wrist"] = true,
    ["Left Foot"] = true,
}

functions.detachStencilProperty = function(reference)
    if not stenciledActors[reference] then return end

    -- Dettach character stencil.
    local sceneNode = reference.sceneNode
    sceneNode:detachProperty(0x3)

    -- Reset vanilla stencils.
    for name in pairs(vanillaStencilObjects) do
        if not vanillaStencilProperties[name] then
            common.logger.error("Cached vanilla stencil property not found.")
        else
            local node = sceneNode:getObjectByName(name)
            if node then
                node:detachProperty(0x3)
                node:attachProperty(vanillaStencilProperties[name])
            end
        end
    end

    sceneNode:update()
    sceneNode:updateNodeEffects()
    sceneNode:updateProperties()
    stenciledActors[reference] = nil

    common.logger.debug("Removed stencil properties from %s.", reference)
end

functions.attachStencilProperty = function(reference)
    if stenciledActors[reference] then return end

    local sceneNode = reference.sceneNode
    sceneNode:detachProperty(0x3)

    if not stencil then
        stencil = tes3.loadMesh(common.paths.stencil):getProperty(0x3)
    end

    -- Load override for arms & legs vanilla stencil property.
    if not stencilArmsAndLegs then
        stencilArmsAndLegs = tes3.loadMesh(common.paths.stencilArmsAndLegs):getProperty(0x3)
    end

    -- Replace vanilla arm and leg stencil property. Cache to reset later.
    for name in pairs(vanillaStencilObjects) do
        local node = sceneNode:getObjectByName(name)
        if node then
            vanillaStencilProperties[name] = node:getProperty(0x3)
            node:detachProperty(0x3)
            node:attachProperty(stencilArmsAndLegs)
        end
    end

    sceneNode:attachProperty(stencil)
    sceneNode:update()
    sceneNode:updateNodeEffects()
    sceneNode:updateProperties()
    stenciledActors[reference] = true

    common.logger.debug("Added stencil properties to %s.", reference)
end


event.register("referenceSceneNodeCreated", function(e)
    if e.reference.object.objectType == tes3.objectType.npc or
        e.reference.object.objectType == tes3.objectType.creature or
        e.reference == tes3.player then
        functions.attachStencilProperty(e.reference)
    end
end)

-- Handle rebuilding scenegraph for stenciled actors.
event.register("referenceSceneNodeCreated", function(e)
    if stenciledActors[e.reference] then
        stenciledActors[e.reference] = nil
        functions.attachStencilProperty(e.reference)
    end
end)
-- When invalidated, scene node will be recreated. Remove from tracking.
event.register("objectInvalidated", function(e)
    stenciledActors[e.object] = nil
end)