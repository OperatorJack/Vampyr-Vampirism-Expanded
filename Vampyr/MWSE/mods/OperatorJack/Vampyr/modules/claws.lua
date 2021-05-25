local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

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

local function calcBloodDraw(vampire, target)
    local h2h = vampire.mobile.handToHand.current
    local luck = vampire.mobile.luck.current
    local crit = 1
    local baseDamage = 5 -- TODO: REPLACE WITH REAL FORMULA / RECONSIDER
    local damage = baseDamage +  h2h * 0.075

    local bloodMod = math.random(0, damage)
    local bloodChance = common.config.clawsBaseChance + h2h / 10 + luck / 20


    local vampHitChance = common.calcHitChance(vampire.mobile, vampire.mobile.handToHand.current)
    local evasionChance = common.calcEvasionChance(target.mobile)
    local hitChance = vampHitChance - evasionChance

    local params = {attackerReference = vampire, targetReference = target, damage = damage, blood = bloodMod, bloodChance = bloodChance, hitChance = hitChance}
    event.trigger(common.events.calcClawModifiers, params)
    damage = params.damage
    bloodMod = params.blood
    bloodChance = params.bloodChance
    hitChance = params.hitChance

    if common.roll(bloodChance) == false then
        bloodMod = 0
    end
    if common.roll(hitChance) == false then
        damage = 0
    end

    return damage, bloodMod
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

-- Hook into damage event for knockdown hand to hand attacks.
event.register("damage", function(e)
    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end
    if e.magicSourceInstance then return end
    if e.projectile then return end
    if e.source == "script" then return end

    local damage, bloodMod = calcBloodDraw(e.attackerReference, e.reference)
    common.debug("Attacking with claws! Attacker: %s, Target: %s, B: %s.  D: %s", e.attackerReference, e.reference, bloodMod, damage)

    e.damage = damage
    if bloodMod > 0 then blood.modReferenceCurrentBloodStatistic(e.attackerReference, bloodMod, true) end
end)


-- Hook into damageHandToHand event for normal hand to hand attacks.
event.register("damageHandToHand", function(e)
    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end

    -- Override fatigue damage so we can implement claw mechanics.
    e.fatigueDamage = 0

    -- Calculate damage and blood gain.
    local damage, bloodMod = calcBloodDraw(e.attackerReference, e.reference)
    common.debug("Attacking with claws! Attacker: %s, Target: %s, B: %s.  D: %s", e.attackerReference, e.reference, bloodMod, damage)

    if damage > 0 then
        local damageMod = e.mobile:applyDamage({
            damage = damage,
            applyArmor = true,
            playerAttack = e.attackerReference == tes3.player,
        })

        common.debug("Damaged with claws. Attacker: %s, Target: %s, Damage Mod: %s", e.attackerReference, e.reference, damageMod)
    end


    if bloodMod > 0 then blood.modReferenceCurrentBloodStatistic(e.attackerReference, bloodMod, true) end
end)