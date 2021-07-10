local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

-- Adapted from Merlord's Brutal Backstabbing. Thanks mate!
local degrees = 80
local angle = (2 * math.pi) * (degrees / 360)

local function isReferenceFacingAway(targetRef, attackerRef)
	-- Check that target is facing away from attacker orientation is between -Pi and Pi.
	-- We get the difference between attacker and target angles, and if it's greater than pie,
	-- we've got the obtuse angle, so subtract 2*pi to get the acute angle.
	local attackerAngle = attackerRef.orientation.z
	local targetAngle = targetRef.orientation.z
	local diff = math.abs (attackerAngle - targetAngle )
	if diff > math.pi then
		diff = math.abs ( diff - ( 2 * math.pi ) )
	end
	-- If the player and attacker have the same orientation, then the attacker must be behind the target
	if ( diff < angle) then
        return true
	end
    return false
end

local function enterFeedMode(targetRef)
    -- Start playing animation
    tes3.messageBox("You begin feeding...")
end

local function feedingKey(e)
    if common.keyDownEqual(e, common.config.feedingActionKey) == false then return end

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
    if isReferenceFacingAway(targetRef, tes3.player) ~= true then
        common.logger.debug("Feed: Player not behind target.")
        tes3.messageBox("You must be behind your target to feed on them.")
        return
    end

    enterFeedMode(targetRef)
end
event.register("keyDown", feedingKey)