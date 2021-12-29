local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")


local targetRef = nil

local movementTick = nil
local feedModeTick = nil

local isFeeding = false
local isCancelled = false
local bloodDrained = 0
local oldPosition = nil
local function exitFeedMode(bypassFinalChecks)
    -- Kill Tick event
    event.unregister("simulate", movementTick)
    event.unregister(common.events.secondPassed, feedModeTick)

     -- Reset animations for NPC
    if targetRef then
        tes3.loadAnimation({reference = targetRef})
        targetRef.mobile.mobToMobCollision = true
        targetRef.position = oldPosition:copy()
    end

    -- Reset animations for Player
    event.trigger(common.events.reloadClawsAnimations, {
        reference = tes3.player
    })
    tes3.playAnimation({
        reference = tes3.player,
        group = tes3.animationGroup.idle,
        startFlag = tes3.animationStartFlag.normal
    })

    -- Reconfigure controls
    tes3.setVanityMode({
        enabled = false
    })
    tes3.mobilePlayer.mouseLookDisabled = false

    -- Stagger NPC
    if not bypassFinalChecks then
        if bloodDrained > 20 and targetRef.mobile.health.current >= 5 then
            tes3.playAnimation({
                reference = targetRef,
                group = tes3.animationGroup.knockDown,
                startFlag = tes3.animationStartFlag.normal,
                loopCount = 0
            })
            targetRef.mobile:startCombat(tes3.player)
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
    targetRef.mobile.mobToMobCollision = false
    targetRef.orientation = tes3.player.orientation:copy()
    targetRef.position = tes3.player.position:copy()
end

feedModeTick = function()
    -- Handle cancellation
    if isCancelled == true or targetRef.mobile.health.current < 5 then
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
    if avg > math.random(0, 25) then
        -- NPC Breaks free
        targetRef.mobile:startCombat(tes3.player)
        tes3.messageBox(common.text.feed_victimDied)
        exitFeedMode(true)
        return
    end

    -- Target Health Reduction
    targetRef.mobile:applyHealthDamage(2)

    -- Player Blood Gain
    bloodDrained = bloodDrained + blood.applyFeedingAction(tes3.player, 2)
end

local function enterFeedMode(ref)
    -- Set target ref
    targetRef = ref
    oldPosition = targetRef.position:copy()

    -- Load animations.
    tes3.loadAnimation({
        reference = tes3.player,
        file = common.animations.feedVampire,
    })

    tes3.loadAnimation({
        reference = targetRef,
        file = common.animations.feedVictim,
    })

    -- Trigger animations.
    tes3.playAnimation({
        reference = tes3.player,
        group = tes3.animationGroup.idle9,
        startFlag = tes3.animationStartFlag.immediate
    })

    tes3.playAnimation({
        reference = targetRef,
        group = tes3.animationGroup.idle9,
        startFlag = tes3.animationStartFlag.immediate
    })

    -- Configure controls
    tes3.mobilePlayer.mouseLookDisabled = true
    tes3.setVanityMode({
        enabled = true
    })

    -- Initiate simulate event.
    isFeeding = true
    event.register(common.events.secondPassed, feedModeTick)
    event.register("simulate", movementTick)
end

local function feedingKey(e)
    if common.keyDownEqual(e, common.config.feedingActionKey) == false then return end

    if isFeeding == true then
        isCancelled = true
    end

    common.logger.debug("Detected Feeding action key.")

    -- Player must be a vampire to feed on targets.
    if common.isPlayerVampire() == false then return end

    local targetRef = tes3.getPlayerTarget()

    -- Target must be a creature or NPC
    if not targetRef then return end
    if targetRef.object.objectType ~= tes3.objectType.creature and targetRef.object.objectType ~= tes3.objectType.npc then
        common.logger.debug("Feed: Target not NPC or creature.")
        return
    end

    -- Player cannot feed on other vampires.
    if targetRef.object.objectType == tes3.objectType.npc and common.isReferenceVampire(targetRef) == true then
        common.logger.debug("Feed: Target is vampire.")
        tes3.messageBox("You cannot feed on other vampires.")
        return
    end

    -- Target and player cannot be in combat.
    local hostileToPlayer = false
    for _, actor in ipairs(targetRef.mobile.hostileActors) do
        if actor == tes3.mobilePlayer then hostileToPlayer = true end
    end
    if targetRef.mobile.inCombat == true and hostileToPlayer == true then
        common.logger.debug("Feed: Target is in combat with player.")
        tes3.messageBox("You cannot feed on targets that are in combat with you.")
        return
    end

    -- Player must be behind target
    if common.isReferenceFacingAway(targetRef, tes3.player) ~= true then
        common.logger.debug("Feed: Player not behind target.")
        tes3.messageBox("You must be behind your target to feed on them.")
        return
    end

    enterFeedMode(targetRef)
end
event.register("keyDown", feedingKey)

local function initialized()
    mwse.overrideScript(common.ids.scripts.initiateFeedOnTarget, function(e)
        timer.start({
            duration = 0.01,
            callback = function ()
                common.logger.debug("Feed: Dialogue route activated. Entering feed mode.")
                local target = tes3.getPlayerTarget()
                enterFeedMode(target)
            end
        })
        mwscript.stopScript{script=common.ids.scripts.initiateFeedOnTarget}
    end)
end

event.register("initialized", initialized)