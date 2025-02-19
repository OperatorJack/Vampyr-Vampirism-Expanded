local common = require("OperatorJack.Vampyr.common")

---@class Vampyr.NodeManager
local this = {}


---@type { [string]: niObject} Key-value table of loaded VFX meshes
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


---@param reference tes3reference
local function reattachStencils(reference)
    -- Initialize player.
    if reference == tes3.player or
        reference == tes3.player1stPerson then
        stenciledActors[reference] = nil
        this.attachStencilProperty(reference)

        -- Reset any stenciled actors since scene node was rebuilt.
    elseif stenciledActors[reference] then
        stenciledActors[reference] = nil
        this.attachStencilProperty(reference)
    end
end

-- Handle initializing and rebuilding scenegraph for stenciled actors.
event.register(tes3.event.referenceSceneNodeCreated, function(e)
    if e.reference == tes3.player then
        reattachStencils(tes3.player1stPerson)
    end
    reattachStencils(e.reference)
end)

-- Handle change in equipment for stenciled actors.
event.register(tes3.event.equipped, function(e)
    timer.delayOneFrame(function()
        if e.reference == tes3.player then
            reattachStencils(tes3.player1stPerson)
        end
        reattachStencils(e.reference)
    end)
end)
event.register(tes3.event.unequipped, function(e)
    timer.delayOneFrame(function()
        if e.reference == tes3.player then
            reattachStencils(tes3.player1stPerson)
        end
        reattachStencils(e.reference)
    end)
end)

-- When invalidated, scene node will be recreated. Remove from tracking.
event.register(tes3.event.objectInvalidated, function(e)
    stenciledActors[e.object] = nil
end)

event.register(tes3.event.initialized, function(e)
    masks = {
        player1st = tes3.loadMesh(common.paths.stencils.player1st):getProperty(ni.propertyType.stencil),
        player = tes3.loadMesh(common.paths.stencils.player):getProperty(ni.propertyType.stencil),
        playerMirror = tes3.loadMesh(common.paths.stencils.playerMirror):getProperty(ni.propertyType.stencil),
        npc = tes3.loadMesh(common.paths.stencils.npc):getProperty(ni.propertyType.stencil),
        npcMirror = tes3.loadMesh(common.paths.stencils.npcMirror):getProperty(ni.propertyType.stencil),
        creature = tes3.loadMesh(common.paths.stencils.creature):getProperty(ni.propertyType.stencil),
        weapon = tes3.loadMesh(common.paths.stencils.weapon):getProperty(ni.propertyType.stencil)
    }
end)

---Attaches stencil property to a given reference.
---@param reference tes3reference
---@param mask niStencilProperty
local function attachStencilPropertyToReference(reference, mask)
    reference.sceneNode:detachProperty(ni.propertyType.stencil)
    reference.sceneNode:attachProperty(mask)
    reference.sceneNode:update()
    reference.sceneNode:updateEffects()
    reference.sceneNode:updateProperties()
    stenciledActors[reference] = true
end

---Attaches stencil mirror properties to a given reference.
---@param reference tes3reference
---@param mask niStencilProperty
local function attachStencilMirrorPropertiesToReference(reference, mask)
    -- Replace vanilla arm and leg stencil property. Cache to reset later.
    for name in pairs(vanillaStencilObjects) do
        local node = reference.sceneNode:getObjectByName(name)
        if node then
            vanillaStencilProperties[name] = node:getProperty(ni.propertyType.stencil)
            node:detachProperty(ni.propertyType.stencil)
            node:attachProperty(mask)
        end
    end
end

---Attaches weapon stencil property to a given reference.
---@param reference tes3reference
---@param mask niStencilProperty
local function attachWeaponStencilPropertyToReference(reference, mask)
    local node = reference.sceneNode:getObjectByName("Weapon Bone")

    if node then
        node:detachProperty(ni.propertyType.stencil)
        node:attachProperty(mask)
    end
end

---Dettaches stencil properties from a given reference.
---@param reference tes3reference
this.detachStencilProperty = function(reference)
    if not stenciledActors[reference] then return end

    -- Dettach character stencil.
    local sceneNode = reference.sceneNode
    if (not sceneNode) then
        return
    end

    sceneNode:detachProperty(ni.propertyType.stencil)

    -- Reset vanilla stencils.
    for name in pairs(vanillaStencilObjects) do
        if not vanillaStencilProperties[name] then
            common.logger.error("Cached vanilla stencil property not found.")
        else
            local node = sceneNode:getObjectByName(name)
            if node then
                node:detachProperty(ni.propertyType.stencil)
                node:attachProperty(vanillaStencilProperties[name])
            end
        end
    end

    sceneNode:update()
    sceneNode:updateEffects()
    sceneNode:updateProperties()
    stenciledActors[reference] = nil

    common.logger.debug("Removed stencil properties from %s.", reference)
end

---Attaches stencil properties to a given reference.
---@param reference tes3reference
this.attachStencilProperty = function(reference)
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

---Gets or attaches VFX to a given reference by the sceneObjectName.
---@param reference tes3reference The reference to attach the VFX to.
---@param sceneObjectName string The name of the VFX object's root node.
---@param path string Path to the VFX
this.getOrAttachVfx = function(reference, sceneObjectName, path)
    local sceneNode = reference.sceneNode
    if (not sceneNode) then return end

    local node = sceneNode:getObjectByName(sceneObjectName)

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
                local heightMod = 1 / height

                local r = node.rotation
                local s = tes3vector3.new(weightMod, weightMod, heightMod)
                node.rotation = tes3matrix33.new(r.x * s, r.y * s, r.z * s)
            end
        end


        sceneNode:attachChild(node, true)
        node:update({ controllers = true })
        node:updateEffects()

        common.logger.debug("Added object %s to %s.", sceneObjectName, reference)
    end

    return node
end

this.showNode = function(node)
    if (node.appCulled == true) then
        node.appCulled = false
    end
end

this.hideNode = function(node)
    if (node.appCulled == false) then
        node.appCulled = true
    end
end

return this
