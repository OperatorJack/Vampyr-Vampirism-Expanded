local common = require("OperatorJack.Vampyr.common")

-- Handle TargetIsVampire global.
local function updateTargetVampireGlobals(ref)
    if ref.object.objectType == tes3.objectType.npc or
        ref.object.objectType == tes3.objectType.creature then
        if common.isReferenceVampire(ref) == true then
            tes3.setGlobal(common.ids.globals.targetIsVampire, 1)
            common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: True", ref)

            local daysSinceLastFeedOn = common.getReferenceDaysSinceLastFeedOn(ref)
            tes3.setGlobal(common.ids.globals.targetDaysSinceLastFeed, daysSinceLastFeedOn)
            common.logger.trace("Target Days Sinces Last Feed On. Ref: %s, Value: %s", ref, daysSinceLastFeedOn)

            local isEmbracedByPlayer = common.isReferenceEmbracedByPlayer(ref)
            tes3.setGlobal(common.ids.globals.targetEmbracedByPlayer, isEmbracedByPlayer)
            common.logger.trace("Target Was Embraced By Player. Ref: %s, Value: %s", ref, isEmbracedByPlayer)

            local countFeedOn = common.getReferenceFeedOnCount(ref)
            tes3.setGlobal(common.ids.globals.targetFeedCount, countFeedOn)
            common.countFeedOn.trace("Target Feed On Count By Player. Ref: %s, Value: %s", ref, countFeedOn)

            local isThrall = common.isReferencedThralled(ref)
            tes3.setGlobal(common.ids.globals.targetIsThrall, isThrall)
            common.countFeedOn.trace("Target Is Thrall. Ref: %s, Value: %s", ref, isThrall)

            local thrallLevel = common.getReferenceThrallLevel(ref)
            tes3.setGlobal(common.ids.globals.targetThrallLevel, thrallLevel)
            common.countFeedOn.trace("Target Thrall Level. Ref: %s, Value: %s", ref, thrallLevel)
        else
            tes3.setGlobal(common.ids.globals.targetIsVampire, 0)
            common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: False", ref)
        end
    else
        tes3.setGlobal(common.ids.globals.targetIsVampire, 0)
        common.logger.trace("Target Is Vampire Global Changed. Ref: %s, Value: False", ref)
    end
end

---@param e activationTargetChangedEventData
local function targetIsVampire(e)
    if not e.current then return end
    updateTargetVampireGlobals(e.current)
end
event.register(tes3.event.activationTargetChanged, targetIsVampire)

---@param e activateEventData
local function activateTargetIsVampire(e)
    if e.activator ~= tes3.player then return end
    updateTargetVampireGlobals(e.target)
end
event.register(tes3.event.activate, activateTargetIsVampire)




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

local function loaded()
    updatePlayerIsVampireGlobal(common.isPlayerVampire())
end
event.register(tes3.event.loaded, loaded)
