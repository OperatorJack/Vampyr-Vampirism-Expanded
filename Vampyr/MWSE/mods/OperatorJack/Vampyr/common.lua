local config = require("OperatorJack.Vampyr.config")
local logger = require("OperatorJack.Vampyr.modules.functions.logger")
local customMessagebox = require("OperatorJack.Vampyr.modules.functions.custom-messagebox")
local shade = require("OperatorJack.Vampyr.modules.functions.shade")
local skinExposure = require("OperatorJack.Vampyr.modules.functions.skin-exposure")

local common = {}

common.config = config
common.logger = logger

common.messageBox = customMessagebox.messageBox
common.createTooltip = customMessagebox.createTooltip

common.shade = shade
common.skinExposure = skinExposure

common.text = {
    bloodSpellFailed = "You do not have enough blood to cast this spell.",

    feed_victimDied = "You consume too much, and your victim dies. Their death drains you.",
    feed_victimBreakFree = "Your victim manages to break free.",
    feed_errorVampire = "You cannot feed on other vampires.",
    feed_errorInCombat = "You cannot while your victim is in combat.",
    feed_errorFacingAway = "You must be behind your victim to feed on them.",

    shadowstepFailed_TooWeak = "You are not powerful enough to shadowstep yet.",
    shadowstepFailed_TooFar = "You do not have enough blood remaining to shadowstep to that position.",
}
common.ids = {
    globals = {
        targetIsVampire = "OJ_V_TargetIsVampire",
        targetDaysSinceLastFeed = "OJ_V_TargetDaysLastFeed",
        targetEmbracedByPlayer = "OJ_V_EmbracedByPlayer",
        targetFeedCount = "OJ_V_TargetFeedCount",
        targetIsThrall = "OJ_V_TargetIsThrall",
        targetThrallLevel = "OJ_V_TargetThrallLevel",
        playerIsVampire = "OJ_V_PlayerIsVampire"
    },
    scripts = {
        initiateFeedOnTarget = "OJ_V_ScriptInitiateFeedOnTarget"
    },

    glamour = {
        cast = "OJ_V_GlamourCast",
        hit = "OJ_V_GlamourHit",
        fadeout = "OJ_V_GlamourFadeout"
    },
    mistform = {
        cast = "OJ_V_MistformCast",
        fadeout = "OJ_V_MistformFadeout",
        hit = "OJ_V_MistformHit",
        light = "OJ_V_MistformHitLight",
    },

    shadowstep = {
        circle = "OJ_V_ShadowstepCircle",
        marker = "OJ_V_ShadowstepMarker",
    },

    serums = {
        mini = "OJ_V_BloodSerum_00",
        small = "OJ_V_BloodSerum_01",
        medium = "OJ_V_BloodSerum_02",
        large = "OJ_V_BloodSerum_03",
        decanter = "OJ_V_BloodSerum_04",
    },

    transfuser = {
        bloodTransfuser = "OJ_V_BloodTransfuser"
    },

    actors = {
        testNpc = "OJ_V_TestNormalNpc",
        testVampire = "OJ_V_TestVampireNpc",
        testHunter = "OJ_V_TestVampireHunter",
    },

    containers = {
        merchant = "OJ_V_MerchantCrate"
    }
}
common.animations = {
    claws = "OJ\\V\\claws.nif",
    clawsFirstPerson = "OJ\\V\\claws.1st.nif",
    feedVampire = "OJ\\V\\feed_vampire.nif",
    feedVictim = "OJ\\V\\feed_victim.nif"
}
common.paths = {
    -- Generic stencil property
    stencils = {
        player1st = "OJ\\V\\stencils\\mask_char1st.nif",
        player = "OJ\\V\\stencils\\mask_char.nif",
        playerMirror = "OJ\\V\\stencils\\mask_char_mirror.nif",
        npc = "OJ\\V\\stencils\\mask_npc.nif",
        npcMirror = "OJ\\V\\stencils\\mask_npc_mirror.nif",
        creature = "OJ\\V\\stencils\\mask_creature.nif",
        weapon = "OJ\\V\\stencils\\mask_weapon.nif",
    },

    -- Requires special node name. Ref overrideSunDamage.lua
    sunDamage = {
        player1st = "OJ\\V\\e\\SunDamageVfx1st.nif",
        player3rd = "OJ\\V\\e\\SunDamageVfx3rd.nif",
        npc = "OJ\\V\\e\\SunDamageVfx_NPC.nif"
    },

    -- Requires special node name. Ref glamour.lua
    glamourVfx = "OJ\\V\\e\\GlamourVfx.nif",

    -- Requires special node name. Ref mistform.lua
    mistform = {
        startVfx = "OJ\\V\\e\\MistformVfxStart.nif",
        endVfx = "OJ\\V\\e\\MistformVfxEnd.nif",
    },

    bloodrainEffect_raindrop = "textures\\Tx_Raindrop_01.tga",
    bloodrainEffect_bloodraindrop = "textures\\V\\OJ_V_Bloodrain.dds"
}
common.filenames = {
    bloodrainEffect_raindrop = "Tx_Raindrop_01.tga",
    bloodrainEffect_bloodraindrop = "OJ_V_Bloodrain.dds",
}
common.spells = {
    satiety = {
        deadSkinOne = "OJ_V_DeadSkinOne",
        deadSkinTwo = "OJ_V_DeadSkinTwo",
        deadSkinThree = "OJ_V_DeadSkinThree",
        deadSkinFour = "OJ_V_DeadSkinFour",
        deadSkinFive = "OJ_V_DeadSkinFive",
        deadSkinSix = "OJ_V_DeadSkinSix",
    },
    drainBlood = "OJ_V_DrainBlood",
    glamour = "OJ_V_Glamour",
    greaterVampiricTouch = "OJ_V_GreaterVampiricTouch",
    greaterVampiricKiss = "OJ_V_GreaterVampiricKiss",
    lesserVampiricTouch = "OJ_V_LsrVampiricTouch",
    lesserVampiricKiss = "OJ_V_LsrVampiricKiss",
    restoreBlood = "OJ_V_RestoreBlood",
    transfusion = "OJ_V_Transfusion",
    vampiricTouch = "OJ_V_VampiricTouch",
    vampiricKiss = "OJ_V_VampiricKiss",
    vampiricIntuition = "OJ_V_VampiricIntuition",
    vampirism = "vampire sun damage",
    weakVampiricTouch = "OJ_V_WeakVampiricTouch",
    weakVampiricKiss = "OJ_V_WeakVampiricKiss",
}
common.bloodSpells = {
    mirage = {
        id = "OJ_V_Mirage",
        cost = 10
    },
    mistform = {
        id = "OJ_V_Mistform",
        cost = 10
    },
    enslave = {
        id = "OJ_V_Enslave",
        cost = 10
    },
    bloodstorm = {
        id = "OJ_V_Bloodstorm",
        cost = 10
    },

    resistSunDamage20 = {
        id = "OJ_V_ResistSunDamage20",
        cost = 10
    },
    resistSunDamage35 = {
        id = "OJ_V_ResistSunDamage35",
        cost = 10
    },
    resistSunDamage50 = {
        id = "OJ_V_ResistSunDamage50",
        cost = 10
    },
    immunitySunDamage = {
        id = "OJ_V_ImmunitySunDamage",
        cost = 10
    },
}

common.events = {
    bloodChanged = "Vampyr:BloodChangedEvent",
    bloodPotencyChanged = "Vampyr:BloodPotencyChangedEvent",
    bloodSatietyChanged = "Vampir:BloodSatietyChangedEvent",
    bloodMagicCostApplied = "Vampyr:BloodMagicCostApplied",
    calcBloodFeedingChance = "Vampyr:CalcBloodFeedingChance",
    calcClawBloodDraw = "Vampyr:CalcClawBloodDraw",
    calcClawDamage = "Vampyr:CalcClawDamage",
    calcSunDamage = "Vampyr:CalcSunDamageScalar",
    calcSunDamageModifiers = "Vampyr:CalcSunDamageScalarModifiers",
    dialogueFilterPcVampire = "Vampyr:DialogueFilterPcVampire",
    playerVampireStateChanged = "Vampyr:PlayerVampireStateChanged",
    initializedReference = "Vampyr:InitializedReference",
    secondPassed = "Vampyr:SecondPassed",
    registerSerums = "Vamypr:RegisterSerums",
    reloadClawsAnimations = "Vampyr:ReloadClawsAnimations"
}

---Rolls a random number and returns true if it is below or equal to the success chance. Used for "dice rolls".
---@param chanceSuccess number The chance success, in number format. EG., 96% = 96.0
---@return boolean Returns true if the rolled number is less than or equal to the chance.
function common.roll(chanceSuccess)
    return math.random(0, 100) <= chanceSuccess
end

---comment Iterates all references within `distance` distance of the target `position`.
---@param position tes3vector3
---@param distance number
---@param filter integer|integer[]|nil The filter to apply to the cell iteration. Passed to `cell:iterateReferences`.
---@return fun(): tes3reference coroutine Coroutine to yield all references within the target area.
function common.iterReferencesNearTargetPosition(position, distance, filter)
    filter = filter or {}
    return coroutine.wrap(function()
        for ref in common.iterReferences(filter) do
            if ref.position:distance(position) <= distance then
                coroutine.yield(ref)
            end
        end
    end)
end

---comment Iterates all references in active cells, filtered by `filter`.
---@param filter integer|integer[]|nil The filter to apply to the cell iteration. Passed to `cell:iterateReferences`.
---@return fun(): tes3reference coroutine Coroutine to yield all references.
function common.iterReferences(filter)
    filter = filter or {}
    return coroutine.wrap(function()
        for _, cell in pairs(tes3.getActiveCells()) do
            for ref in cell:iterateReferences(filter) do
                coroutine.yield(ref)
            end
        end
    end)
end

---Gets the key of a table from a custom search function, func.
---@param tbl table The table to search.
---@param func function The function to check with. The function should accept one paramter, `value`.
---@return string|nil key The key, if any.
function common.getKeyFromValueFunc(tbl, func)
    for key, value in pairs(tbl) do
        if (func(value) == true) then return key end
    end
    return nil
end

---Calculates hit chance for a mobile with a specific weapon skill using the vanilla hit formula.
---@param mobile tes3mobileActor The mobile to calculate hit chance for.
---@param currentWeaponSkill number The skill level of the mobile's current weapon.
---@return number chance The hit chance.
function common.calcHitChance(mobile, currentWeaponSkill)
    -- From UESP: (Weapon Skill + (Agility / 5) + (Luck / 10)) * (0.75 + 0.5 * Current Fatigue / Maximum Fatigue) + Fortify Attack Magnitude + Blind Magnitude

    return (currentWeaponSkill + (mobile.agility.current / 5) + (mobile.luck.current / 10)) *
        (0.75 + 0.5 * mobile.fatigue.current / mobile.fatigue.base) + mobile.attackBonus + mobile.blind
end

---Calculates evasion chance for a mobile using the vanilla evasian formula.
---@param mobile tes3mobileActor The mobile to calculate evasion chance for.
---@return number chance The evasian chance.
function common.calcEvasionChance(mobile)
    -- From UESP: ((Agility / 5) + (Luck / 10)) * (0.75 + 0.5 * Current Fatigue / Maximum Fatigue) + Sanctuary Magnitude

    return (mobile.agility.current / 5) + (mobile.luck.current / 10) +
        (0.75 + 0.5 * mobile.fatigue.current / mobile.fatigue.base) + mobile.sanctuary
end

--- Determines if the reference is a vampire. Returns true if so.
---@param reference tes3reference The reference to check vampirism for.
function common.isReferenceVampire(reference)
    return tes3.isAffectedBy({
        reference = reference,
        effect = tes3.effect.vampirism
    })
end

--- Determines if the player is a vampire. Returns true if so.
function common.isPlayerVampire()
    return common.isReferenceVampire(tes3.player)
end

--- Determines if an object ID belongs to a serum. Returns true if so.
---@param id string The object ID to check for.
function common.isSerum(id)
    for _, serumId in pairs(common.ids.serums) do
        if id == serumId then
            return true
        end
    end
    return false
end

--- Determines if a faction ID belongs to a vampire faction. Returns true if so.
---@param id string The faction ID to check for.
function common.isVampireFaction(id)
    for factionId in pairs(config.vampireFactions) do
        if id == factionId then
            return true
        end
    end
    return false
end

--- Determines if the reference is a vampire merchant and sells the provided object types. Returns true if both criteria are met.
---@param ref tes3reference The reference to check if is a vampire merchant.
---@param objectTypes tes3.objectType[] Filter of the object types to determine if they're a merchant for. Eg., if weapons is provided, true is only returned if the merchant is a vampire and sells weapons.
function common.isVampireMerchant(ref, objectTypes)
    if not common.isReferenceVampire(ref) == true then return false end

    for objectType in pairs(objectTypes) do
        if ref.object:tradesItemType(objectType) == false then return false end
    end

    return true
end

--- Appropriately deletes (yeets) the reference without breaking things.
---@param ref tes3reference
---@param no any
function common.yeet(ref, no)
    if no then
        mwse.error("You called yeet() with a colon, didn't you?")
    end
    ref:delete()
end

--- Safely initializes Vampyr reference data on the reference, so that it can be accessed elsewhere.
---@param reference tes3reference
function common.initializeReferenceData(reference)
    if (reference.data.OJ_VAMPYR == nil) then
        reference.data.OJ_VAMPYR = {
            blood = {
                base = -1,
                current = -1,
            },
            bloodInitialized = false,
            lastFeedDay = tes3.worldController.daysPassed.value,
            isVampire = common.isReferenceVampire(reference),
        }
        event.trigger(common.events.initializedReference, {
            reference = reference
        })
    end
end

-- Adapted from Merlord's Brutal Backstabbing. Thanks mate!
local degrees = 80
local angle = (2 * math.pi) * (degrees / 360)

--- Checks if the attacker is behind the target and the target is facing away (eg., for backstabbing)
---@param targetRef tes3reference The target reference which may be facing away.
---@param attackerRef tes3reference The attacker reference which may be facing the target's back.
---@return boolean _ If the target is facing away.
function common.isReferenceFacingAway(targetRef, attackerRef)
    -- Check that target is facing away from attacker orientation is between -Pi and Pi.
    -- We get the difference between attacker and target angles, and if it's greater than pie,
    -- we've got the obtuse angle, so subtract 2*pi to get the acute angle.
    local attackerAngle = attackerRef.orientation.z
    local targetAngle = targetRef.orientation.z
    local diff = math.abs(attackerAngle - targetAngle)
    if diff > math.pi then
        diff = math.abs(diff - (2 * math.pi))
    end
    -- If the player and attacker have the same orientation, then the attacker must be behind the target
    if (diff < angle) then
        return true
    end
    return false
end

return common
