--[[
    This module fixes issues with vanilla NPC vampires. This cuurrently includes:

    - Adds the Vampirism effect to to NPCs which are vampires, but do not have the vampirism disease.
 ]]

local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")


local function onInitFixNpcVampires()
    local spell = tes3.getObject(common.spells.vampirism)
    ---@cast spell tes3spell

    for id in pairs(config.fakeNpcVampires) do
        local npc = tes3.getObject(id)
        ---@cast npc tes3actor
        if (npc) then
            tes3.addSpell({ actor = npc, spell = spell })
        end
    end
end
event.register(tes3.event.initialized, onInitFixNpcVampires)
