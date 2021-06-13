local common = require("OperatorJack.Vampyr.common")

local functions = {}

local stenciledActors = {}

local masks = {}

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

local function attachStencilPropertyToReference(reference, mask)
    reference.sceneNode:detachProperty(0x3)
    reference.sceneNode:attachProperty(mask)
    reference.sceneNode:update()
    reference.sceneNode:updateNodeEffects()
    reference.sceneNode:updateProperties()
    stenciledActors[reference] = true
end

local function attachStencilMirrorPropertiesToReference(reference, mask)
    -- Replace vanilla arm and leg stencil property. Cache to reset later.
    for name in pairs(vanillaStencilObjects) do
        local node = reference.sceneNode:getObjectByName(name)
        if node then
            vanillaStencilProperties[name] = node:getProperty(0x3)
            node:detachProperty(0x3)
            node:attachProperty(mask)
        end
    end
end

functions.attachStencilProperty = function(reference)
    if stenciledActors[reference] then return end

    local mask
    local maskMirror

    -- Set mask paths & process
    if reference == tes3.player then
        mask= masks.player
        maskMirror = masks.playerMirror

        attachStencilMirrorPropertiesToReference(tes3.player, maskMirror)
        --attachStencilMirrorPropertiesToReference(tes3.firstPersonReference, maskMirror)

        attachStencilPropertyToReference(tes3.player, mask)
        --attachStencilPropertyToReference(tes3.firstPersonReference, mask)

    elseif reference.object.objectType == tes3.objectType.npc then
        mask= masks.npc
        maskMirror = masks.npcMirror

        attachStencilMirrorPropertiesToReference(reference, maskMirror)
        attachStencilPropertyToReference(reference, mask)

    elseif reference.object.objectType == tes3.objectType.creature then
        mask = masks.creature

        attachStencilPropertyToReference(reference, mask)

    end

    common.logger.debug("Added stencil properties to %s.", reference)
end


-- Handle initializing and rebuilding scenegraph for stenciled actors.
event.register("referenceSceneNodeCreated", function(e)
    if  e.reference.object.objectType == tes3.objectType.npc or
        e.reference.object.objectType == tes3.objectType.creature or
        e.reference == tes3.player then
        stenciledActors[e.reference] = nil
        functions.attachStencilProperty(e.reference)
    end
end)

-- When invalidated, scene node will be recreated. Remove from tracking.
event.register("objectInvalidated", function(e)
    stenciledActors[e.object] = nil
end)

event.register("initialized", function(e)
    masks = {
        player = tes3.loadMesh("OJ\\stencils\\mask_char.nif"):getProperty(0x3),
        playerMirror = tes3.loadMesh("OJ\\stencils\\mask_char_mirror.nif"):getProperty(0x3),
        npc = tes3.loadMesh("OJ\\stencils\\mask_npc.nif"):getProperty(0x3),
        npcMirror = tes3.loadMesh("OJ\\stencils\\mask_npc_mirror.nif"):getProperty(0x3),
        creature = tes3.loadMesh("OJ\\stencils\\mask_creature.nif"):getProperty(0x3)
    }
end)