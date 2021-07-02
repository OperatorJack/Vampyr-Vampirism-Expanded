local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")

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

local items = {
    [1] = common.ids.serums.mini,
    [2] = common.ids.serums.small,
    [3] = common.ids.serums.medium,
    [4] = common.ids.serums.large,
    [5] = common.ids.serums.decanter,
    [6] = common.ids.transfuser.bloodTransfuser,
}
local function showItemMenu()
        local message = "Vampyr Debug Menu - Items"
        local buttons = {}
        for _, itemId in ipairs(items) do
            table.insert(buttons, {
                text = tes3.getObject(itemId).name,
                callback = function()
                    mwscript.addItem({
                        reference = tes3.player,
                        item = itemId
                    })
                end,
            })
        end

        common.messageBox{
            message = message,
            buttons = buttons,
            doesCancel = true
        }
end

local actors = {
    [1] = common.ids.actors.testHunter,
    [2] = common.ids.actors.testNpc,
    [3] = common.ids.actors.testVampire,
}
local function showActorsMenu()
        local message = "Vampyr Debug Menu - Actors"
        local buttons = {}
        for _ , actorId in pairs(actors) do
            table.insert(buttons, {
                text = tes3.getObject(actorId).name,
                callback = function()
                    mwscript.placeAtPC({
                        reference = tes3.player,
                        object = actorId
                    })
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
            {
                text = "Items",
                callback = function()
                    showItemMenu()
                end,
            },
            {
                text = "Actors",
                callback = function()
                    showActorsMenu()
                end,
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