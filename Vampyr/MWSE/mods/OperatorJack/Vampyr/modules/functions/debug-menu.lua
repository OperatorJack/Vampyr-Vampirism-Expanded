local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

local bloodMenuVals = {
    [1] = -500,
    [2] = -50,
    [3] = -5,
    [4] = 5,
    [5] = 50,
    [6] = 500,
}

local function showBloodMenu(func)
        local message = "Vampyr Debug Menu - Blood Levels"
        local buttons = {}
        for _, bloodAmount in ipairs(bloodMenuVals) do
            table.insert(buttons, {
                text = tostring(bloodAmount),
                callback = function()
                    func(bloodAmount)
                    local bloodStat = blood.getPlayerBloodStatistic()
                    tes3.messageBox("Current: " .. bloodStat.current .. " , Max: " .. bloodStat.base)
                end,
            })
        end

        common.messageBox{
            message = message,
            buttons = buttons,
            doesCancel = true
        }
end

local function debugMenuKey(e)
    if common.config.enableDebugMenu == true and common.keyDownEqual(e, common.config.debugMenuKey) == true then
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
                text = "Modify Base Blood",
                requirements = common.isPlayerVampire,
                callback = function()
                    showBloodMenu(blood.modPlayerBaseBloodStatistic)

                end,
                tooltipDisabled = {
                    text = "You must be a vampire."
                },
            },
            {
                text = "Modify Current Blood",
                requirements = common.isPlayerVampire,
                callback = function()
                    showBloodMenu(blood.modPlayerCurrentBloodStatistic)
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