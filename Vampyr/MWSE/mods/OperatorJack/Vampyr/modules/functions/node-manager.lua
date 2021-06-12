
local common = require("OperatorJack.Vampyr.common")
local functions = {}

local vfx = {}

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