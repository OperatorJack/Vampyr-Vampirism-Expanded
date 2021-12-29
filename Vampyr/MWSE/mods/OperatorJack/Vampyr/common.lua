local config = require("OperatorJack.Vampyr.config")
local logger = require("OperatorJack.Vampyr.modules.functions.logger")
local customMessagebox = require ("OperatorJack.Vampyr.modules.functions.custom-messagebox")
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

    shadowstepFailed_TooWeak = "You are not powerful enough to shadowstep yet.",
    shadowstepFailed_TooFar = "You do not have enough blood remaining to shadowstep to that position.",
}
common.ids = {
    globals = {
        targetIsVampire = "OJ_V_TargetIsVampire",
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
    feedVictim = "OJ\\V\\feed_vampire.nif"
}
common.paths = {
    -- Generic stencil property
    stencils = {
        player1st = "OJ\\stencils\\mask_char1st.nif",
        player = "OJ\\stencils\\mask_char.nif",
        playerMirror = "OJ\\stencils\\mask_char_mirror.nif",
        npc = "OJ\\stencils\\mask_npc.nif",
        npcMirror = "OJ\\stencils\\mask_npc_mirror.nif",
        creature = "OJ\\stencils\\mask_creature.nif",
        weapon = "OJ\\stencils\\mask_weapon.nif",
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
    bloodMagicCostApplied = "Vampyr:BloodMagicCostApplied",
    calcClawBloodDraw = "Vampyr:CalcClawBloodDraw",
    calcClawDamage = "Vampyr:CalcClawDamage",
    calcSunDamage = "Vampyr:CalcSunDamageScalar",
    calcSunDamageModifiers = "Vampyr:CalcSunDamageScalarModifiers",
    dialogueFilterPcVampire = "Vampyr:DialogueFilterPcVampire",
    playerVampireStateChanged = "Vampyr:PlayerVampireStateChanged",
    initializedReference = "Vampyr:InitializedReference",
    secondPassed = "Vampyr:SecondPassed",
    reloadClawsAnimations = "Vampyr:ReloadClawsAnimations"
}


function common.roll(chanceSuccess)
    return math.random(0, 100) <= chanceSuccess
end

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

function common.keyDownEqual(eventKeyDown, configKeyDown)
    if eventKeyDown.keyCode == configKeyDown.keyCode and
        eventKeyDown.isAltDown == configKeyDown.isAltDown and
        eventKeyDown.isShiftDown == configKeyDown.isShiftDown and
        eventKeyDown.isControlDown == configKeyDown.isControlDown then
           return true
    end
    return false
end

function common.getKeyFromValueFunc(tbl, func)
    for key, value in pairs(tbl) do
        if (func(value) == true) then return key end
    end
    return nil
end

function common.calcHitChance(mobile, currentWeaponSkill)
     -- From UESP: (Weapon Skill + (Agility / 5) + (Luck / 10)) * (0.75 + 0.5 * Current Fatigue / Maximum Fatigue) + Fortify Attack Magnitude + Blind Magnitude

    return (currentWeaponSkill + (mobile.agility.current / 5) + (mobile.luck.current / 10)) * (0.75 + 0.5 * mobile.fatigue.current / mobile.fatigue.base) + mobile.attackBonus + mobile.blind
end

function common.calcEvasionChance(mobile)
    -- From UESP: ((Agility / 5) + (Luck / 10)) * (0.75 + 0.5 * Current Fatigue / Maximum Fatigue) + Sanctuary Magnitude

    return (mobile.agility.current / 5) + (mobile.luck.current / 10) + (0.75 + 0.5 * mobile.fatigue.current / mobile.fatigue.base) + mobile.sanctuary
end

function common.isReferenceVampire(reference)
    return tes3.isAffectedBy({
        reference = reference,
        effect = tes3.effect.vampirism
    })
end

function common.isPlayerVampire()
    return common.isReferenceVampire(tes3.player)
end

function common.isSerum(id)
    for _, serumId in pairs(common.ids.serums) do
        if id == serumId then
            return true
        end
    end
    return false
end

function common.isVampireFaction(id)
    for factionId in pairs(config.vampireFactions) do
        if id == factionId then
            return true
        end
    end
    return false
end

function common.isVampireMerchant(ref, objectTypes)
    if not common.isReferenceVampire(ref) == true then return false end

    for objectType in pairs(objectTypes) do
        if ref.object:tradesItemType(objectType) == false then return false end
    end

    return true
end

--TODO: Null needs to fix collision crashes on Disable/Delete
function common.yeet(ref, no)
    if no then
        mwse.error("You called yeet() with a colon, didn't you?")
    end
    ref:disable()
    mwscript.setDelete{ reference = ref}
end

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

return common