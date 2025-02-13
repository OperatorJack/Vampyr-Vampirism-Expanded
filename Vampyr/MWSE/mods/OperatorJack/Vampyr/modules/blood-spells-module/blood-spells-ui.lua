local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

local function onUiSpellTooltip(e)
    local spell = e.spell
    local bloodSpellKey = common.getKeyFromValueFunc(common.bloodSpells, function(value)
        if (value.id == spell.id) then
            return true
        end
    end)
    local bloodSpell = common.bloodSpells[bloodSpellKey]
    if (not bloodSpell) then
        return
    end

    local cost = bloodSpell.cost

    local outerBlock = e.tooltip:createBlock()
    outerBlock.flowDirection = "top_to_bottom"
    outerBlock.widthProportional = 1
    outerBlock.autoHeight = true
    outerBlock.borderAllSides = 4

    outerBlock:createDivider()

    local innerBlock = outerBlock:createBlock()
    innerBlock.flowDirection = "left_to_right"
    innerBlock.widthProportional = 1
    innerBlock.autoHeight = true
    innerBlock.borderAllSides = 0

    local text = string.format("Blood Cost: %s", math.floor(cost))
    local referenceBlood = blood.getPlayerBloodStatistic()
    local color = tes3ui.getPalette("normal_color")
    if (cost > referenceBlood.current) then
        tierColor = tes3ui.getPalette("negative_color")
    end

    local label = innerBlock:createLabel({ text = text })
    label.color = color
    label.borderAllSides = 4
end
event.register(tes3.event.uiSpellTooltip, onUiSpellTooltip)
