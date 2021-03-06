
local common = require("OperatorJack.Vampyr.common")
local functions = {}

local vfx = {}

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
    ["Left Pauldron"] = true,
}


local function reattachStencils(e)
    -- Initialize player.
    if  e.reference == tes3.player or
        e.reference == tes3.player1stPerson then
        stenciledActors[e.reference] = nil
        functions.attachStencilProperty(e.reference)

    -- Reset any stenciled actors since scene node was rebuilt.
    elseif stenciledActors[e.reference] then
        stenciledActors[e.reference] = nil
        functions.attachStencilProperty(e.reference)
    end
end

-- Handle initializing and rebuilding scenegraph for stenciled actors.
event.register("referenceSceneNodeCreated", reattachStencils)

-- Handle change in equipment for stenciled actors.
event.register("equipped", function(e)
    timer.delayOneFrame(function()
        if e.reference == tes3.player then
            reattachStencils({reference = tes3.player1stPerson})
        end
        reattachStencils(e)
    end)
end)
event.register("unequipped", function(e)
    timer.delayOneFrame(function()
        if e.reference == tes3.player then
            reattachStencils({reference = tes3.player1stPerson})
        end
        reattachStencils(e)
    end)
end)

-- When invalidated, scene node will be recreated. Remove from tracking.
event.register("objectInvalidated", function(e)
    stenciledActors[e.object] = nil
end)

event.register("initialized", function(e)
    masks = {
        player1st = tes3.loadMesh(common.paths.stencils.player1st):getProperty(0x3),
        player = tes3.loadMesh(common.paths.stencils.player):getProperty(0x3),
        playerMirror = tes3.loadMesh(common.paths.stencils.playerMirror):getProperty(0x3),
        npc = tes3.loadMesh(common.paths.stencils.npc):getProperty(0x3),
        npcMirror = tes3.loadMesh(common.paths.stencils.npcMirror):getProperty(0x3),
        creature = tes3.loadMesh(common.paths.stencils.creature):getProperty(0x3),
        weapon = tes3.loadMesh(common.paths.stencils.weapon):getProperty(0x3)
    }
end)

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

local function attachWeaponStencilPropertyToReference(reference, mask)
    local node = reference.sceneNode:getObjectByName("Weapon Bone")

    if node then
        node:detachProperty(0x3)
        node:attachProperty(mask)
    end
end

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

    -- Set mask paths & process
    if reference == tes3.player then
        attachStencilMirrorPropertiesToReference(reference, masks.playerMirror)
        attachWeaponStencilPropertyToReference(reference, masks.weapon)
        attachStencilPropertyToReference(reference, masks.player)

    elseif reference == tes3.player1stPerson then
        attachWeaponStencilPropertyToReference(reference, masks.weapon)
        attachStencilPropertyToReference(reference, masks.player1st)

    elseif reference.object.objectType == tes3.objectType.npc then
        attachStencilMirrorPropertiesToReference(reference, masks.npcMirror)
        attachWeaponStencilPropertyToReference(reference, masks.weapon)
        attachStencilPropertyToReference(reference, masks.npc)

    elseif reference.object.objectType == tes3.objectType.creature then
        attachWeaponStencilPropertyToReference(reference, masks.weapon)
        attachStencilPropertyToReference(reference, masks.creature)

    end

    common.logger.debug("Added stencil properties to %s.", reference)
end

functions.getOrAttachVfx = function(reference, sceneObjectName, path)
    local node, sceneNode
    sceneNode = reference.sceneNode
    node = sceneNode:getObjectByName(sceneObjectName)

    if (not node) then
        if not vfx[sceneObjectName] then
            vfx[sceneObjectName] = tes3.loadMesh(path)
        end
        node = vfx[sceneObjectName]:clone()

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
        node:update({controllers=true})
        node:updateNodeEffects()

        common.logger.debug("Added object %s to %s.", sceneObjectName, reference)
    end

    return node
end

functions.showNode = function(node)
    if (node.appCulled == true) then
        node.appCulled = false
    end
end

functions.hideNode = function(node)
    if (node.appCulled == false) then
        node.appCulled = true
    end
end

return functions