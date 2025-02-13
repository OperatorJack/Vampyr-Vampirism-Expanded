local common = require("OperatorJack.Vampyr.common")
local bloodSatiety = require("OperatorJack.Vampyr.modules.blood-Satiety-module.blood-Satiety")

local function onBloodChanged(e)
    bloodSatiety.setLevel(e.reference, bloodSatiety.calculateBloodSatiety(e.reference))
end
event.register(common.events.bloodChanged, onBloodChanged)

local actions = {
    add = 1,
    remove = 2
}
local ladder = {
    [1] = {
        [common.spells.satiety.deadSkinOne] = actions.add,
    },
    [2] = {
        [common.spells.satiety.deadSkinTwo] = actions.add,
        [common.spells.satiety.deadSkinOne] = actions.remove,
    },
    [3] = {
        [common.spells.satiety.deadSkinThree] = actions.add,
        [common.spells.satiety.deadSkinTwo] = actions.remove,
    },
    [4] = {
        [common.spells.satiety.deadSkinFour] = actions.add,
        [common.spells.satiety.deadSkinThree] = actions.remove,
    },
    [5] = {
        [common.spells.satiety.deadSkinFive] = actions.add,
        [common.spells.satiety.deadSkinFour] = actions.remove,
    },
    [6] = {
        [common.spells.satiety.deadSkinSix] = actions.add,
        [common.spells.satiety.deadSkinFive] = actions.remove,
    }
}

event.register(common.events.bloodSatietyChanged, function(e)
    local ref = e.reference
    local increased = true
    if (e.previousSatiety) then
        if (e.previousSatiety > e.currentSatiety) then
            increased = false
        end
    end

    if increased == true then
        for spellId in pairs(ladder[e.currentSatiety]) do
            if ladder[e.currentSatiety][spellId] == actions.add then
                common.logger.trace("Adding spell %s to reference %s", spellId, ref)
                tes3.addSpell({ reference = ref, spell = spellId })
            else
                common.logger.trace("Removing spell %s from reference %s", spellId, ref)
                tes3.removeSpell({ reference = ref, spell = spellId })
            end
        end
    else
        for spellId in pairs(ladder[e.previousSatiety]) do
            if ladder[e.previousSatiety][spellId] == actions.add then
                common.logger.trace("Removing spell %s from reference %s", spellId, ref)
                tes3.removeSpell({ reference = ref, spell = spellId })
            else
                common.logger.trace("Adding spell %s to reference %s", spellId, ref)
                tes3.addSpell({ reference = ref, spell = spellId })
            end
        end
    end
end)
