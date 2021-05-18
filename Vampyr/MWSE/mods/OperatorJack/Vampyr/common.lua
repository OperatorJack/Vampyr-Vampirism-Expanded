local config = require("OperatorJack.Vampyr.config")
local common = {}

common.text = {
    bloodSpellFailed = "You do not have enough blood to cast this spell.",

    shadowstepFailed_TooWeak = "You are not powerful enough to shadowstep yet.",
    shadowstepFailed_TooFar = "You do not have enough blood remaining to shadowstep to that position.",
}
common.ids = {
    mistform = {
        fadeout = "OJ_V_MistformFadeout"
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
common.paths = {
    -- Requires special node name. Ref overrideSunDamage.lua
    sunDamageVfx = "OJ\\V\\e\\SunDamageVfx.nif",

    -- Requires special node name. Ref effects.lua
    mistformVfx = "OJ\\V\\e\\MistformVfx.nif",
    mistformEndVfx = "OJ\\V\\e\\MistformEndVfx.nif",

    bloodrainEffect_raindrop = "textures\\Tx_Raindrop_01.tga",
    bloodrainEffect_bloodraindrop = "textures\\V\\OJ_V_Bloodrain.dds"
}
common.filenames = {
    bloodrainEffect_raindrop = "Tx_Raindrop_01.tga",
    bloodrainEffect_bloodraindrop = "OJ_V_Bloodrain.dds",
}
common.spells = {
    vampirism = "vampire sun damage",
    restoreBlood = "OJ_V_RestoreBlood",
    drainBlood = "OJ_V_DrainBlood",
    weakVampiricTouch = "OJ_V_WeakVampiricTouch",
    weakVampiricKiss = "OJ_V_WeakVampiricKiss",
    lesserVampiricTouch = "OJ_V_LsrVampiricTouch",
    lesserVampiricKiss = "OJ_V_LsrVampiricKiss",
    vampiricTouch = "OJ_V_VampiricTouch",
    vampiricKiss = "OJ_V_VampiricKiss",
    greaterVampiricTouch = "OJ_V_GreaterVampiricTouch",
    greaterVampiricKiss = "OJ_V_GreaterVampiricKiss",
    glamour = "OJ_V_Glamour",
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

    bloodSummonBat = {
        id = "OJ_V_BloodSummonBat",
        cost = 10
    },
    bloodSummonDaedroth = {
        id = "OJ_V_BloodSummonDaedroth",
        cost = 10
    },
    bloodSummonDremora = {
        id = "OJ_V_BloodSummonDremora",
        cost = 10
    },
}

common.events = {
    bloodChanged = "Vampyr:BloodChangedEvent",
    bloodPotencyChanged = "Vampyr:BloodPotencyChangedEvent",
    playerVampireStateChanged = "Vampyr:PlayerVampireStateChanged",
    initializedReference = "Vampyr:InitializedReference",
    secondPassed = "Vampyr:SecondPassed",
    bloodMagicCostApplied = "Vampyr:BloodMagicCostApplied"
}

function common.debug(message)
    if (config.debug == true) then
        tes3.messageBox(message)
        mwse.log("[Vampyr: Debug] %s", message)
    end
end

function common.getKeyFromValueFunc(tbl, func)
    for key, value in pairs(tbl) do
        if (func(value) == true) then return key end
    end
    return nil
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