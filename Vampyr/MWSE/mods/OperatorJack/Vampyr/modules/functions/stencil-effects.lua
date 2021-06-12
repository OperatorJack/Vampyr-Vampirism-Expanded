local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

event.register("referenceSceneNodeCreated", function(e)
    if e.reference.object.objectType == tes3.objectType.npc or
        e.reference.object.objectType == tes3.objectType.creature or
        e.reference == tes3.player then
        nodeManager.attachStencilProperty(e.reference)
    end
end)