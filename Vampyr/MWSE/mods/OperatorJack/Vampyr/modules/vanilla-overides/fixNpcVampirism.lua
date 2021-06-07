--[[ 
    This module fixes issues with vanilla NPC vampires. This cuurrently includes:

    - Adds the Vampirism effect to to NPCs which are vampires, but do not have the vampirism disease.
 ]]
 
local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")


local function onInitFixNpcVampires(e)
    local spell = tes3.getObject(common.spells.vampirism)
    for id in pairs(config.fakeNpcVampires) do
        local npc = tes3.getObject(id)
        if (npc) then
            npc.spells:add(spell)
        end
    end
end
event.register("initialized", onInitFixNpcVampires)