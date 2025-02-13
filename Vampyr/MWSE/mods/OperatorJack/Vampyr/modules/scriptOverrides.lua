local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")
local common = require("OperatorJack.Vampyr.common")

local function initialized()
    mwse.overrideScript("OJ_VAMPYR_TestBecomeVampire", function(e)
        common.initializeReferenceData(tes3.player)

        timer.start({
            duration = 2,
            callback = function()
                tes3.messageBox("Making Player a vampire..")
                tes3.addSpell({ reference = tes3.player, spell = common.spells.vampirism })
                tes3.addSpell({ reference = tes3.player, spell = common.spells.restoreBlood })
                tes3.addSpell({ reference = tes3.player, spell = common.spells.drainBlood })
                tes3.addSpell({ reference = tes3.player, spell = common.bloodSpells.bloodstorm.id })

                timer.start({
                    duration = 10,
                    iterations = 10,
                    callback = function()
                        blood.modPlayerBaseBloodStatistic(30)
                        blood.modPlayerCurrentBloodStatistic(25)
                        local bloodStat = blood.getPlayerBloodStatistic()
                        tes3.messageBox("Current: " .. bloodStat.current .. " , Max: " .. bloodStat.base)
                    end
                })
            end
        })

        common.logger.debug("Executed Lua Script Override OJ_VAMPYR_TestBecomeVampire")
        tes3.stopLegacyScript({ script = "OJ_VAMPYR_TestBecomeVampire" })
    end)

    common.logger.info("Registered Script Overrides")
end

event.register(tes3.event.initialized, initialized)
