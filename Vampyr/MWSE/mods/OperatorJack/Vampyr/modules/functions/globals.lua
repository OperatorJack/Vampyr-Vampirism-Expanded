local common = require("OperatorJack.Vampyr.common")

-- Handle TargetIsVampire global.
local function updateTargetIsVampireGlobal(ref)
    if ref.object.objectType == tes3.objectType.npc or
        ref.object.objectType == tes3.objectType.creature then
        if common.isReferenceVampire(ref) == true then
            tes3.setGlobal(common.ids.globals.targetIsVampire, 1)
            common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: True", ref)
        else
            tes3.setGlobal(common.ids.globals.targetIsVampire, 0)
            common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: False", ref)
        end
    else
        tes3.setGlobal(common.ids.globals.targetIsVampire, 0)
        common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: False", ref)
    end
end

local function targetIsVampire(e)
    if not e.current then return end
    updateTargetIsVampireGlobal(e.current)
end
event.register("activationTargetChanged", targetIsVampire)

local function activateTargetIsVampire(e)
    if e.activator ~= tes3.player then return end
    updateTargetIsVampireGlobal(e.target)
end
event.register("activate", activateTargetIsVampire)




-- Handle PlayerIsVampire global.
local function updatePlayerIsVampireGlobal(isVampire)
    local globalValue = 0
    if isVampire == true then
        globalValue = 1
    end

    tes3.setGlobal(common.ids.globals.playerIsVampire, globalValue)
    common.logger.trace("Player Is Vampire Global Changed. Value: %s", isVampire)
end

local function playerVampireStateChanged(e)
    updatePlayerIsVampireGlobal(e.isVampire)
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

local function loaded(e)
    updatePlayerIsVampireGlobal(common.isPlayerVampire())
end
event.register("loaded", loaded)