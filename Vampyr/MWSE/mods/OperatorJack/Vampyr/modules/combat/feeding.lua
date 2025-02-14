local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")


local targetRef = nil

local movementTick = function()
    common.logger:error("Unexpected call to uninitialized movementTick function.")
end
local feedModeTick = function()
    common.logger:error("Unexpected call to uninitialized feedModeTick function.")
end

local isFeeding = false
local isHostile = true
local isCancelled = false
local bloodDrained = 0
local oldPosition = nil
local oldHello = nil
local function exitFeedMode(bypassFinalChecks)
    -- Kill Tick event
    event.unregister(tes3.event.simulate, movementTick)
    event.unregister(common.events.secondPassed, feedModeTick)

    -- Reset animations for NPC
    if targetRef then
        targetRef.position = oldPosition
        targetRef.mobile.hello = oldHello

        targetRef.mobile.mobToMobCollision = true
        targetRef.mobile.movementCollision = true

        tes3.loadAnimation({ reference = targetRef })
    end

    tes3.mobilePlayer.mobToMobCollision = true
    tes3.mobilePlayer.movementCollision = true

    -- Reset animations for Player
    event.trigger(common.events.reloadClawsAnimations, { reference = tes3.player })
    tes3.playAnimation({
        reference = tes3.player,
        group = tes3.animationGroup.idle,
    })

    -- Reconfigure controls
    tes3.mobilePlayer.mouseLookDisabled = false

    -- Stagger NPC
    if not bypassFinalChecks and targetRef then
        targetRef.mobile:startCombat(tes3.mobilePlayer)

        if bloodDrained > 20 and targetRef.mobile.health.current >= 5 then
            tes3.playAnimation({
                reference = targetRef,
                group = tes3.animationGroup.knockDown,
                loopCount = 0
            })
        end
        if targetRef.mobile.health.current < 5 then
            targetRef.mobile:applyHealthDamage(5)
            blood.modPlayerBaseBloodStatistic(-1 * targetRef.mobile.health.base)
            tes3.messageBox(common.text.feed_victimDied)
        end
    end

    -- Reset variables
    targetRef = nil
    isCancelled = false
    isFeeding = false
    bloodDrained = 0
    oldPosition = nil
end

movementTick = function()
    if not targetRef then
        event.unregister(tes3.event.simulate, movementTick)
        return
    end

    targetRef.orientation = tes3.player.orientation
    targetRef.position = tes3.player.position
end

feedModeTick = function()
    -- Handle cancellation
    if isCancelled == true or not targetRef or targetRef.mobile.health.current < 5 then
        exitFeedMode()
        return
    end

    -- [[Process tick]]
    -- Trigger crime
    tes3.triggerCrime({
        criminal = tes3.player,
        victim = targetRef,
        type = tes3.crimeType.attack,
        value = 250,
    })

    -- Target Willpower Check
    local willpower = targetRef.mobile.willpower.current - tes3.mobilePlayer.willpower.current
    local strength = targetRef.mobile.strength.current - tes3.mobilePlayer.strength.current
    local avg = (willpower + strength) / 2

    -- If average is more than 25, NPC is much more powerful than player.
    if avg > math.random(0, 25) and isHostile == true then
        -- NPC Breaks free
        targetRef.mobile:startCombat(tes3.player)
        tes3.messageBox(common.text.feed_victimBreakFree)
        exitFeedMode(true)
        return
    end

    -- Target Health Reduction
    targetRef.mobile:applyHealthDamage(2)

    -- Player Blood Gain
    bloodDrained = bloodDrained + blood.applyFeedingAction(tes3.player, 2)
end

local function enterFeedMode(params)
    local ref = params.target
    isHostile = params.hostile or true
    isFeeding = true

    -- Set target ref
    targetRef = ref
    oldPosition = ref.position:copy()
    oldHello = ref.mobile.hello

    -- Configure controls.
    tes3.mobilePlayer.mouseLookDisabled = true

    -- Prevent Greetings.
    ref.mobile.hello = 0

    -- Disable physics.
    ref.mobile.velocity = { 0, 0, 0 }
    ref.mobile.mobToMobCollision = false
    ref.mobile.movementCollision = false

    tes3.mobilePlayer.velocity = tes3vector3.new(0, 0, 0)
    tes3.mobilePlayer.mobToMobCollision = false
    tes3.mobilePlayer.movementCollision = false

    -- Reset animations.
    tes3.playAnimation { reference = tes3.player, group = tes3.animationGroup.idle }
    tes3.playAnimation { reference = ref, group = tes3.animationGroup.idle }

    -- Trigger animations.
    timer.start {
        duration = 0.1,
        iterations = 1,
        callback = function()
            tes3.playAnimation({
                reference = tes3.player,
                mesh = common.animations.feedVampire,
                group = tes3.animationGroup.idle9,
                idleAnim = true,
            })
            tes3.playAnimation({
                reference = ref,
                mesh = common.animations.feedVictim,
                group = tes3.animationGroup.idle9,
                idleAnim = true,
            })
            -- Initiate simulate event.
            event.unregister(common.events.secondPassed, feedModeTick)
            event.register(common.events.secondPassed, feedModeTick)
            event.unregister(tes3.event.simulate, movementTick)
            event.register(tes3.event.simulate, movementTick)
        end
    }
end

local function feedingKey(e)
    if tes3.isKeyEqual({ actual = e, expected = common.config.feedingActionKey }) == false or not tes3.player then return end

    if isFeeding == true then
        isCancelled = true
        return
    end

    common.logger.debug("Detected Feeding action key.")

    -- Player must be a vampire to feed on targets.
    if common.isPlayerVampire() == false then return end

    local targetRef = tes3.getPlayerTarget()

    -- Target must be a NPC
    if not targetRef then return end
    if targetRef.object.objectType ~= tes3.objectType.npc then
        common.logger.debug("Feed: Target not NPC.")
        return
    end

    -- Target must be close to NPC.
    if targetRef.position:distance(tes3.player.position) > 128 then
        common.logger.debug("Feed: Target is too far away.")
        return
    end

    -- Player cannot feed on other vampires.
    if targetRef.object.objectType == tes3.objectType.npc and common.isReferenceVampire(targetRef) == true then
        common.logger.debug("Feed: Target is vampire.")
        tes3.messageBox(common.text.feed_errorVampire)
        return
    end

    -- Target and player cannot be in combat.
    local hostileToPlayer = false
    for _, actor in ipairs(targetRef.mobile.hostileActors) do
        if actor == tes3.mobilePlayer then hostileToPlayer = true end
    end
    if targetRef.mobile.inCombat == true and hostileToPlayer == true then
        common.logger.debug("Feed: Target is in combat with player.")
        tes3.messageBox(common.text.feed_errorInCombat)
        return
    end

    -- Player must be behind target
    if common.isReferenceFacingAway(targetRef, tes3.player) ~= true then
        common.logger.debug("Feed: Player not behind target.")
        tes3.messageBox(common.text.feed_errorFacingAway)
        return
    end

    enterFeedMode({
        target = targetRef,
        hostile = true
    })
end
event.register(tes3.event.keyDown, feedingKey)

local exports = {
    enterFeedMode = enterFeedMode,
    exitFeedMode = exitFeedMode
}
return exports
