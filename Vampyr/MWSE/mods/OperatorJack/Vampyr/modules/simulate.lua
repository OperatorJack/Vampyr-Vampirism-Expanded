local common = require("OperatorJack.Vampyr.common")

local function checkPlayerVampireState(e)
    if (tes3.player.data.OJ_VAMPYR.isVampire ~= common.isPlayerVampire()) then
        common.logger.debug("Player vampire state changed.")

        tes3.player.data.OJ_VAMPYR.isVampire = not tes3.player.data.OJ_VAMPYR.isVampire
        event.trigger(common.events.playerVampireStateChanged, {
            isVampire = tes3.player.data.OJ_VAMPYR.isVampire
        })
    end
end
event.register(common.events.secondPassed, checkPlayerVampireState)

local function onLoaded()
    timer.start({
        duration = 1,
        iterations = -1,
        callback = function()
            event.trigger(common.events.secondPassed, {
                timestamp = tes3.getSimulationTimestamp()
            })
        end
    })
end
event.register(tes3.event.loaded, onLoaded)
