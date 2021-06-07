--[[
    This module handles the blood user-interface mechanics, including the player HUD UI and skill window UI.

    - Adds Blood bar in standard HUD.
    - Adds Blood bar in Skills menu.
]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")


-- Register UI for standard HUD.
local ids = {
    BloodFillbarBlock = tes3ui.registerID("Vampyr:BloodFillbarBlock"),
    BloodFillbar = tes3ui.registerID("Vampyr:BloodFillbar"),
    BloodFillbarColorbar = tes3ui.registerID("Vampyr:BloodFillbarColorbar"),
    BloodFillbarText = tes3ui.registerID("Vampyr:BloodFillbarText"),

    BloodStatLayout = tes3ui.registerID("Vampyr:BloodStatLayout"),
    BloodStatText = tes3ui.registerID("Vampyr:BloodStatText"),
    BloodStatFillbar = tes3ui.registerID("Vampyr:BloodStatFillbar")
}

local function updateFillbar(fillbar)
    local currentBlood = blood.getPlayerBloodStatistic()
    fillbar.widget.current = currentBlood.current
    fillbar.widget.max = currentBlood.base

    local r = 0.65 * math.max(0.2, (currentBlood.current / currentBlood.base))
    fillbar.widget.fillColor = {r, 0.0, 0.0}
end

local function updateBloodVisibility(bloodStatFillbar, bloodHUDFillbar)
    if common.isPlayerVampire() == true then
        if (bloodHUDFillbar) then bloodHUDFillbar.visible = true end
        if (bloodStatFillbar) then bloodStatFillbar.visible = true end
    else
        if (bloodHUDFillbar) then bloodHUDFillbar.visible = false end
        if (bloodStatFillbar) then bloodStatFillbar.visible = false end
    end
end

local function createBloodHUDFillbar(element)

    local bloodFillbarBlock = element:createRect({
        id = ids.BloodFillbarBlock,
        color = {0.0, 0.0, 0.0}
    })
    bloodFillbarBlock.width = 65
    bloodFillbarBlock.height = 12
    bloodFillbarBlock.borderAllSides = 2
    bloodFillbarBlock.alpha = 0.8

        local bloodFillbar = bloodFillbarBlock:createFillBar({id = ids.BloodFillbar})
        bloodFillbar.width = 65
        bloodFillbar.height = 12
        bloodFillbar.widget.fillColor = { 0.65, 0.0, 0.0}
        bloodFillbar.widget.showText = false
        updateFillbar(bloodFillbar)

    if (config.uiBloodFillbarOnTop == true) then
        element:reorderChildren(0, -1, 1)
    end
    element:updateLayout()

    return bloodFillbarBlock
end

local function createBloodStatFillbar(element)
    local bloodStatLayout = element:createBlock({
        id = ids.BloodStatLayout,
    })
    bloodStatLayout.width = 204
    bloodStatLayout.height = 18
    bloodStatLayout.widthProportional = 1
    bloodStatLayout.borderAllSides = 0
    bloodStatLayout.paddingAllSides = 0
    bloodStatLayout.childAlignX = -1
    bloodStatLayout.childAlignY = 0.5
    bloodStatLayout.flowDirection = "left_to_right"

        -- Add Text, spacer, fillbar.
        local bloodStatText = bloodStatLayout:createLabel({
            id = ids.BloodStatText,
            text = "Blood"
        })
        bloodStatText.color = {0.875, 0.788, 0.624}
        bloodStatText.width = 48
        bloodStatText.height = 18
        bloodStatText.borderAllSides = 0
        bloodStatText.borderRight = 5

        bloodStatLayout:createBlock()

        local bloodStatFillbar = bloodStatLayout:createFillBar({id = ids.BloodStatFillbar})
        bloodStatFillbar.width = 130
        bloodStatFillbar.height = 18
        bloodStatFillbar.widget.showText = true
        updateFillbar(bloodStatFillbar)

    if (config.uiBloodFillbarOnTop == true) then
            element:reorderChildren(0, -1, 1)
    end
    element:updateLayout()

    return bloodStatLayout
end

local menuMultiFillbarsBlock
local bloodHUDFillbar
local function updateMenuMultiBloodFillbarFromBloodChanged(e)
    if (not menuMultiFillbarsBlock) then return end
    if (e.reference ~= tes3.player) then return end

    -- Destroy existing element.
    local bloodFillbar = menuMultiFillbarsBlock:findChild(ids.BloodFillbar)
    if (bloodFillbar) then
        updateFillbar(bloodFillbar)
    end

    menuMultiFillbarsBlock:updateLayout()
end
event.register(common.events.bloodChanged, updateMenuMultiBloodFillbarFromBloodChanged)

local function createMenuMultiBloodFillbar(e)
    if not e.newlyCreated then return end

    -- Find the UI element that holds the fillbars.
    menuMultiFillbarsBlock = e.element:findChild(tes3ui.registerID("MenuMulti_fillbars_layout"))
    bloodHUDFillbar = createBloodHUDFillbar(menuMultiFillbarsBlock)
    updateBloodVisibility(nil, bloodHUDFillbar)
end
event.register("uiActivated", createMenuMultiBloodFillbar, { filter = "MenuMulti" })


local menuStatFillbarsBlock
local bloodStatFillbar
local function updateMenuStatBloodFillbarFromBloodChanged(e)
    if (not menuStatFillbarsBlock) then return end
    if (e.reference ~= tes3.player) then return end

    -- Update existing element.
    local bloodFillbar = menuStatFillbarsBlock:findChild(ids.BloodStatFillbar)
    if (bloodFillbar) then
        updateFillbar(bloodFillbar)
    end

    menuStatFillbarsBlock:updateLayout()
end
event.register(common.events.bloodChanged, updateMenuStatBloodFillbarFromBloodChanged)

local function createMenuStatBloodFillbar(e)
    if not e.newlyCreated then return end

    -- Find the UI element that holds the fillbars.
    menuStatFillbarsBlock = e.element:findChild(tes3ui.registerID("MenuStat_mini_frame"))
    bloodStatFillbar = createBloodStatFillbar(menuStatFillbarsBlock)
    updateBloodVisibility(bloodStatFillbar, nil)
end
event.register("uiActivated", createMenuStatBloodFillbar, { filter = "MenuStat" })

local function playerVampireStateChanged()
    updateBloodVisibility(bloodStatFillbar, bloodHUDFillbar)
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged, { priority = -1})

local function vampireBloodTooltip(e)
    if e.reference == nil then return end
    if e.object.objectType ~= tes3.objectType.npc then return end
    if common.isPlayerVampire() == false then return end
    if common.isReferenceVampire(e.reference) == false then return end
    if tes3.isAffectedBy({reference = tes3.player, effect = tes3.effect.auspex}) == false then return end

    common.initializeReferenceData(e.reference)
    local currentBlood = blood.getReferenceBloodStatistic(e.reference)

    local bloodBlock = e.tooltip:createBlock()
    bloodBlock.flowDirection = "left_to_right"
    bloodBlock.childAlignX = 0
    bloodBlock.autoHeight = true
    bloodBlock.autoWidth = true
    bloodBlock.paddingAllSides  = 3

    local bar = bloodBlock:createFillBar({
        current = currentBlood.current,
        max = currentBlood.base
    })
    bar.widget.fillColor = {60, 0.0, 0.0}
end
event.register("uiObjectTooltip", vampireBloodTooltip, {priority = -1})

local function npcBloodTooltip(e)
    if e.reference == nil then return end
    if e.object.objectType ~= tes3.objectType.npc then return end
    if common.isPlayerVampire() == false then return end
    if common.isReferenceVampire(e.reference) == true then return end
    if tes3.isAffectedBy({reference = tes3.player, effect = tes3.effect.auspex}) == false then return end

    local current, base = blood.calculateFeedBlood(e.reference.mobile)
    local bloodBlock = e.tooltip:createBlock()
    bloodBlock.flowDirection = "left_to_right"
    bloodBlock.childAlignX = 0
    bloodBlock.autoHeight = true
    bloodBlock.autoWidth = true
    bloodBlock.paddingAllSides = 3

    local bar = bloodBlock:createFillBar({
        current = current,
        max = base
    })
    bar.widget.fillColor = tes3ui.getPalette("health_color")
end
event.register("uiObjectTooltip", npcBloodTooltip, {priority = -1})