--[[
    This module handles the blood potency user-interface mechanics.

    - Adds Blood Potency to NPC tooltips.
    - Adds Blood Potency text in Skills menu.
]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency")


-- Register UI for standard HUD.
local ids = {
    BloodPotencyStatLayout = tes3ui.registerID("Vampyr:BloodPotencyStatLayout"),
    BloodPotencyStatText = tes3ui.registerID("Vampyr:BloodPotencyStatText"),
    BloodPotencyStatLabel = tes3ui.registerID("Vampyr:BloodPotencyStatLabel")
}

local function updateBloodPotencyText(bloodPotencyStatText)
    local level = bloodPotency.getLevel(tes3.player)
    local honorary = bloodPotency.getLevelNameFromLevel(level)
    bloodPotencyStatText.text = honorary
end

local function updateBloodPotencyVisibility(bloodPotencyStatLayout)
    if common.isPlayerVampire() == true then
        if (bloodPotencyStatLayout) then bloodPotencyStatLayout.visible = true end
    else
        if (bloodPotencyStatLayout) then bloodPotencyStatLayout.visible = false end
    end
end

local function createBloodPotencyLayout(element)
    local layout = element:createBlock({
        id = ids.BloodPotencyStatLayout,
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
            id = ids.BloodPotencyStatLabel,
            text = "Potency"
        })
        label.color = {0.875, 0.788, 0.624}
        label.width = 38
        label.height = 18
        label.borderAllSides = 0
        label.borderRight = 5

        local spacer = layout:createBlock()
        spacer.autoWidth = true

        local text = layout:createLabel({
            id = ids.BloodPotencyStatText
        })
        text.width = 58
        text.height = 18
        text.borderAllSides = 0
        updateBloodPotencyText(text)

    element:updateLayout()

    return layout
end

local menuStatPlayerBlock
local bloodPotencyStatLayout
local function updateMenuStatBloodPotencyFromBloodPotencyChanged(e)
    if (not menuStatPlayerBlock) then return end
    if (e.reference ~= tes3.player) then return end

    -- Update existing element.
    local text = menuStatPlayerBlock:findChild(ids.BloodPotencyStatText)
    if (text) then
        updateBloodPotencyText(text)
    end

    menuStatPlayerBlock:updateLayout()
end
event.register(common.events.bloodPotencyChanged, updateMenuStatBloodPotencyFromBloodPotencyChanged)

local function createMenuStatBloodPotency(e)
    if not e.newlyCreated then return end

    -- Find the UI element that holds the fillbars.
    menuStatPlayerBlock = e.element:findChild(tes3ui.registerID("MenuStat_class_layout")).parent
    bloodPotencyStatLayout = createBloodPotencyLayout(menuStatPlayerBlock)
    updateBloodPotencyVisibility(bloodPotencyStatLayout)
end
event.register("uiActivated", createMenuStatBloodPotency, { filter = "MenuStat" })

local function playerVampireStateChanged()
    updateBloodPotencyVisibility(bloodPotencyStatLayout)
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

local function vampireBloodPotencyTooltip(e)
    if e.reference == nil then return end
    if e.object.objectType ~= tes3.objectType.npc then return end
    if common.isPlayerVampire() == false then return end
    if common.isReferenceVampire(e.reference) == false then return end
    if tes3.isAffectedBy({reference = tes3.player, effect = tes3.effect.auspex}) == false then return end

    common.initializeReferenceData(e.reference)

    local level = bloodPotency.getLevel(e.reference)
    local honorary = bloodPotency.getLevelNameFromLevel(level)

    local bloodBlock = e.tooltip:createBlock()
    bloodBlock.flowDirection = "left_to_right"
    bloodBlock.childAlignX = 0
    bloodBlock.autoHeight = true
    bloodBlock.autoWidth = true
    bloodBlock.paddingAllSides  = 3

    -- TODO: Add text to tooltip.
    local label = bloodBlock:createLabel({
        text = string.format("Potency: %s", honorary)
    })

end
event.register("uiObjectTooltip", vampireBloodPotencyTooltip, {priority = -2})