local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

local function keyDownEqual(eventKeyDown, configKeyDown)
    if eventKeyDown.keyCode == configKeyDown.keyCode and
        eventKeyDown.isAltDown == configKeyDown.isAltDown and
        eventKeyDown.isShiftDown == configKeyDown.isShiftDown and
        eventKeyDown.isControlDown == configKeyDown.isControlDown then
           return true
    end
    return false
end

local function debugMenuKey(e)
    if common.config.enableDebugMenu == true and keyDownEqual(e, common.config.debugMenuKey) == true then
        local message = "Vampyr Debug Menu"
        local buttons = {
            {
                text = "Become Vampire",
                requirements = function() return not common.isPlayerVampire() end,
                callback = function()
                    mwscript.addSpell{reference = tes3.player, spell = common.spells.vampirism}
                end,
                tooltipDisabled = {
                    text = "You are already a vampire."
                },
            },
            {
                text = "Cure Vampirism",
                requirements = common.isPlayerVampire,
                callback = function()
                    mwscript.removeSpell{reference = tes3.player, spell = common.spells.vampirism}
                end,
                tooltipDisabled = {
                    text = "You must be a vampire."
                },
            },
            {
                text = "Add 50 Base Blood",
                requirements = common.isPlayerVampire,
                callback = function()
                    blood.modPlayerBaseBloodStatistic(50)
                    local bloodStat = blood.getPlayerBloodStatistic()
                    tes3.messageBox("Current: " .. bloodStat.current .. " , Max: " .. bloodStat.base)
                end,
                tooltipDisabled = {
                    text = "You must be a vampire."
                },
            },
            {
                text = "Add 50 Current Blood",
                requirements = common.isPlayerVampire,
                callback = function()
                    blood.modPlayerCurrentBloodStatistic(50)
                    local bloodStat = blood.getPlayerBloodStatistic()
                    tes3.messageBox("Current: " .. bloodStat.current .. " , Max: " .. bloodStat.base)
                end,
                tooltipDisabled = {
                    text = "You must be a vampire."
                },
            },
        }
        common.messageBox{
            message = message,
            buttons = buttons,
            doesCancel = true
        }
    end
end
event.register("keyDown", debugMenuKey)