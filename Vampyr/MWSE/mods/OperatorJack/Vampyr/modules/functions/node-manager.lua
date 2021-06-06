
local common = require("OperatorJack.Vampyr.common")
local functions = {}

local vfx = {}

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
            node:detachProperty(0x3)
            node:attachProperty(vanillaStencilProperties[name])
        end
    end

    sceneNode:update()
    sceneNode:updateNodeEffects()
    stenciledActors[reference] = nil
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
        node = sceneNode:getObjectByName(name)
        vanillaStencilProperties[name] = sceneNode:getProperty(0x3)
        sceneNode:detachProperty(0x3)
        sceneNode:attachProperty(stencilArmsAndLegs)
    end

    sceneNode:attachProperty(stencil)
    sceneNode:update()
    sceneNode:updateNodeEffects()
    stenciledActors[reference] = true

    common.logger.trace("Attached %s to %s. Property: ", stencil.RTTI.name, reference, sceneNode:getProperty(0x3))
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
        sceneNode:update()
        sceneNode:updateNodeEffects()
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