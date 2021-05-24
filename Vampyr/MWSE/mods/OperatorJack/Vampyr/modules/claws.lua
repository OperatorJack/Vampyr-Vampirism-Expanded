local common = require("OperatorJack.Vampyr.common")

local cache = {}

event.register("objectInvalidated", function(e)
    cache[e.object] = nil
end)

local function setAnimation(ref)
    -- Avoid reloading animations to prevent FPS drops.
    if cache[ref] then return end

    common.debug("Enabling claw animations for %s.", ref)

    tes3.loadAnimation({
        reference = ref,
        file = common.animations.claws,
    })

    if ref == tes3.player then
        tes3.loadAnimation({
            reference = tes3.player1stPerson,
            file = common.animations.clawsFirstPerson,
        })
    end

    cache[ref] = true
end

local function calcBloodDraw(source, target)
    local sourceH2h = source.mobile.handToHand.current
    local targetArmorRating = target.mobile.armorRating
end

-- Set Animations
local function playerVampireStateChanged(e)
    if (e.isVampire == true) then
        setAnimation(tes3.player)
    end
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

event.register("loaded", function(e)
    if common.isPlayerVampire() == true then
        setAnimation(tes3.player)
    end
end)

event.register("combatStart", function(e)
    if common.isReferenceVampire(e.actor.reference) == true then
        setAnimation(e.actor.reference)
    end

    if common.isReferenceVampire(e.target.reference) == true then
        setAnimation(e.target.reference)
    end
end)

-- Handle Claws mechanics
event.register("damage", function(e)
    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end
    if e.magicSourceInstance then return end
    if e.project then return end

    common.debug("Attacking with claws! %s", e.attackerReference.readiedWeapon)



end)


event.register("damageHandToHand", function(e)
    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end
    if e.magicSourceInstance then return end
    if e.project then return end

    -- Override fatigue damage so we can implement claw mechanics.
    e.fatigueDamage = 0

    common.debug("Attacking with claws! %s", e.attackerReference.readiedWeapon)



end)