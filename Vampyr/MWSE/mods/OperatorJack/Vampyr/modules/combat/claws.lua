local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

local cache = {}

event.register("objectInvalidated", function(e)
    cache[e.object] = nil
end)

local function setAnimation(ref)
    -- Avoid reloading animations to prevent FPS drops.
    if cache[ref] then return end

    -- Beast races use standard animations.
    if ref.object.race.isBeast == true then return end

    common.logger.debug("Enabling claw animations for %s.", ref)

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

local function calcClawDamage(vampire, target)
    local h2h = math.min(vampire.mobile.handToHand.current, 150)
    local luck = vampire.mobile.luck.current
    local crit = 1
    local baseDamage = 5 -- TODO: REPLACE WITH REAL FORMULA / RECONSIDER
    local damage = baseDamage +  h2h * 0.075

    local params = {attackerReference = vampire, targetReference = target, damage = damage}
    event.trigger(common.events.calcClawDamage, params)
    damage = params.damage

    return damage
end

local function calcBloodDraw(vampire, target, damage)
    local h2h = math.min(vampire.mobile.handToHand.current, 150)
    local luck = vampire.mobile.luck.current

    local bloodDraw = math.random(0, damage)
    local bloodChance = common.config.clawsBaseChance + h2h / 10 + luck / 20


    local params = {attackerReference = vampire, targetReference = target, blood = bloodDraw, bloodChance = bloodChance}
    event.trigger(common.events.calcClawBloodDraw, params)
    bloodDraw = params.blood
    bloodChance = params.bloodChance

    if common.roll(bloodChance) == false then
        bloodDraw = 0
    end

    return bloodDraw
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

    if e.target and common.isReferenceVampire(e.target.reference) == true then
        setAnimation(e.target.reference)
    end
end)

-- Handle Claws mechanics

-- Hook into damage event for knockdown hand to hand attacks. Receive forwarded event from `damageHandToHand`.
local forwardedEvent = false
local forwardedAttackerReference = nil

event.register("damage", function(e)
    local attackerReference = e.attackerReference
    if forwardedEvent == true then
        attackerReference = forwardedAttackerReference
    else
        if not e.attackerReference then return end
        if common.isReferenceVampire(e.attackerReference) == false then return end
        if e.attackerReference.readiedWeapon then return end
        if e.magicSourceInstance then return end
        if e.projectile then return end
        if e.source == "script" then return end

        -- Only needed for normal attacks, as damage is already taken into account in `damageHandToHand`.
        e.damage = calcClawDamage(attackerReference, e.reference)
        e.damage = e.reference.mobile:calcEffectiveDamage({
            damage = e.damage,
            applyArmor = true,
        })
    end

    -- reset forwardedEvent for next damageHandToHand event
    forwardedEvent = false
    forwardedAttackerReference = nil

    local bloodDraw = calcBloodDraw(attackerReference, e.reference, e.damage)
    common.logger.debug("Attacking with claws! Attacker: %s, Target: %s, B: %s.  D: %s", attackerReference, e.reference, bloodDraw, e.damage)

    if bloodDraw > 0 then
        blood.modReferenceCurrentBloodStatistic(attackerReference, bloodDraw, true)
        blood.applyFeedingAction(attackerReference, bloodDraw * .25)
    end

    -- Block other event handlers.
    return false
end, {priority = 1000})


-- Hook into damageHandToHand event for normal hand to hand attacks.
event.register("damageHandToHand", function(e)
    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end

    -- Override fatigue damage so we can implement claw damage mechanics. Set to 1 to still trigger HUD element.
    e.fatigueDamage = 1

    -- Let damage handler know the next trigger comes from this code.
    forwardedEvent = true
    forwardedAttackerReference = e.attackerReference

    -- Provide value to applyDamage. Overwritten in damage handler.
    local damage = calcClawDamage(e.attackerReference, e.reference)

    e.mobile:applyDamage({
        damage = damage,
        applyArmor = true,
        playerAttack = e.attackerReference == tes3.player,
    })

    common.logger.debug("Forwarded damageHandTohand to damage event via applyDamage. Attacker: %s, Target: %s", e.attackerReference, e.reference)


    -- Block other event handlers.
    return false
end, {priority = 1000})