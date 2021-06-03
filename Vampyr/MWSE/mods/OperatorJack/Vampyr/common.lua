local config = require("OperatorJack.Vampyr.config")
local logger = require("OperatorJack.Vampyr.modules.functions.logger")
local common = {}

common.config = config
common.logger = logger

common.text = {
    bloodSpellFailed = "You do not have enough blood to cast this spell.",

    shadowstepFailed_TooWeak = "You are not powerful enough to shadowstep yet.",
    shadowstepFailed_TooFar = "You do not have enough blood remaining to shadowstep to that position.",
}
common.ids = {
    glamour = {
        fadeout = "OJ_V_GlamourFadeout"
    },
    mistform = {
        cast = "OJ_V_MistformCast",
        fadeout = "OJ_V_MistformFadeout",
        hit = "OJ_V_MistformHit",
    },

    shadowstep = {
        circle = "OJ_V_ShadowstepCircle",
        marker = "OJ_V_ShadowstepMarker",
    },

    potions = {
        smallRestoreBlood = "OJ_V_SmallVialRestoreBlood",
        mediumRestoreBlood = "OJ_V_MediumVialRestoreBlood",
        largeRestoreBlood = "OJ_V_LargeVialRestoreBlood",
    }
}
common.animations = {
    claws = "OJ\\V\\claws.nif",
    clawsFirstPerson = "OJ\\V\\claws.1st.nif",
}
common.paths = {
    -- Requires special node name. Ref overrideSunDamage.lua
    sunDamageVfx = "OJ\\V\\e\\SunDamageVfx.nif",

    -- Requires special node name. Ref glamour.lua
    glamourVfx = "OJ\\V\\e\\GlamourVfx.nif",

    -- Requires special node name. Ref mistform.lua
    mistformStartVfx = "OJ\\V\\e\\MistformVfxStart.nif",

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
    playerVampireStateChanged = "Vampyr:PlayerVampireStateChanged",
    initializedReference = "Vampyr:InitializedReference",
    secondPassed = "Vampyr:SecondPassed",
}


function common.roll(chanceSuccess)
    return math.random(0, 100) <= chanceSuccess
end

function common.iterReferencesNearTargetPosition(position, distance, filter)
    filter = filter or {}
    return coroutine.wrap(function()
        for _, cell in pairs(tes3.getActiveCells()) do
            for ref in cell:iterateReferences(filter) do
                if ref.position:distance(position) <= distance then
                    coroutine.yield(ref)
                end
            end
        end
    end)
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

function common.isPositionInShadow(position)
    if (tes3.player.cell.isInterior and not tes3.player.cell.behaveAsExterior) then
        return true
    end

    local hour = tes3.worldController.hour.value
    if (hour < 4 or hour > 20)then
        return true
    end

    local sunPos = tes3.worldController.weatherController.sceneSunBase.worldTransform.translation
    local sunLightDirection = (sunPos - position):normalized()
    local result = tes3.rayTest({
        position = position,
        direction = sunLightDirection,
        ignore = { tes3.player }
    })
    if (result) then
        return true
    end

    return false
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

function common.initializeReferenceData(reference)
    if (reference.data.OJ_VAMPYR == nil) then
        reference.data.OJ_VAMPYR = {
            blood = {
                base = -1,
                current = -1,
            },
            bloodInitialized = false,
            lastFeedDay = tes3.worldController.daysPassed.value,
            isVampire = common.isReferenceVampire(reference)
        }
        event.trigger(common.events.initializedReference, {
            reference = reference
        })
    end
end

return common