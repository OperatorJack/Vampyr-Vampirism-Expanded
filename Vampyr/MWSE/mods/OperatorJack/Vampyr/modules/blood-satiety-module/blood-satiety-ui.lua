--[[
    This module handles the blood Satiety user-interface mechanics.

    - Adds Blood Satiety to NPC tooltips.
    - Adds Blood Satiety text in Skills menu.
]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")
local bloodSatiety = require("OperatorJack.Vampyr.modules.blood-satiety-module.blood-satiety")


-- Register UI for standard HUD.
local ids = {
    BloodSatietyStatLayout = tes3ui.registerID("Vampyr:BloodSatietyStatLayout"),
    BloodSatietyStatText = tes3ui.registerID("Vampyr:BloodSatietyStatText"),
    BloodSatietyStatLabel = tes3ui.registerID("Vampyr:BloodSatietyStatLabel")
}

local function updateBloodSatietyText(bloodSatietyStatText)
    local honorary = bloodSatiety.getLevelNameFromLevel(bloodSatiety.getLevel(tes3.player))
    bloodSatietyStatText.text = honorary
end

local function updateBloodSatietyVisibility(bloodSatietyStatLayout)
    if common.isPlayerVampire() == true then
        if (bloodSatietyStatLayout) then bloodSatietyStatLayout.visible = true end
    else
        if (bloodSatietyStatLayout) then bloodSatietyStatLayout.visible = false end
    end
end

local function createBloodSatietyLayout(element)
    local layout = element:createBlock({
        id = ids.BloodSatietyStatLayout,
    })
    layout.width = 204
    layout.height = 18
    layout.widthProportional = 1
    layout.borderAllSides = 0
    layout.paddingAllSides = 0
    layout.childAlignX = -1
    layout.childAlignY = 0.5
    layout.flowDirection = "left_to_right"

    -- Add Text, spacer, fillbar.
    local label = layout:createLabel({
        id = ids.BloodSatietyStatLabel,
        text = "Satiety"
    })
    label.color = { 0.875, 0.788, 0.624 }
    label.width = 38
    label.height = 18
    label.borderAllSides = 0
    label.borderRight = 5

    local spacer = layout:createBlock()
    spacer.autoWidth = true

    local text = layout:createLabel({
        id = ids.BloodSatietyStatText
    })
    text.width = 58
    text.height = 18
    text.borderAllSides = 0
    updateBloodSatietyText(text)

    element:updateLayout()

    return layout
end

local menuStatPlayerBlock
local bloodSatietyStatLayout
local function updateMenuStatBloodSatietyFromBloodSatietyChanged(e)
    if (not menuStatPlayerBlock) then return end
    if (e.reference ~= tes3.player) then return end

    -- Update existing element.
    local text = menuStatPlayerBlock:findChild(ids.BloodSatietyStatText)
    if (text) then
        updateBloodSatietyText(text)
    end

    menuStatPlayerBlock:updateLayout()
end
event.register(common.events.bloodSatietyChanged, updateMenuStatBloodSatietyFromBloodSatietyChanged)

local function createMenuStatBloodSatiety(e)
    if not e.newlyCreated then return end

    -- Find the UI element that holds the fillbars.
    menuStatPlayerBlock = e.element:findChild(tes3ui.registerID("MenuStat_class_layout")).parent
    bloodSatietyStatLayout = createBloodSatietyLayout(menuStatPlayerBlock)
    updateBloodSatietyVisibility(bloodSatietyStatLayout)
end
event.register(tes3.event.uiActivated, createMenuStatBloodSatiety, { filter = "MenuStat", priority = -3 })

local function playerVampireStateChanged()
    updateBloodSatietyVisibility(bloodSatietyStatLayout)
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

local function vampireBloodSatietyTooltip(e)
    if e.reference == nil then return end
    if e.object.objectType ~= tes3.objectType.npc then return end
    if common.isPlayerVampire() == false then return end
    if common.isReferenceVampire(e.reference) == false then return end
    if tes3.isAffectedBy({ reference = tes3.player, effect = tes3.effect.auspex }) == false then return end

    common.initializeReferenceData(e.reference)
    local honorary             = bloodSatiety.getLevelNameFromLevel(bloodSatiety.getLevel(tes3.player))

    local bloodBlock           = e.tooltip:createBlock()
    bloodBlock.flowDirection   = "left_to_right"
    bloodBlock.childAlignX     = 0
    bloodBlock.autoHeight      = true
    bloodBlock.autoWidth       = true
    bloodBlock.paddingAllSides = 3

    -- TODO: Add text to tooltip.
    local label                = bloodBlock:createLabel({
        text = string.format("Satiety: %s", honorary)
    })
end
event.register(tes3.event.uiObjectTooltip, vampireBloodSatietyTooltip, { priority = -3 })
