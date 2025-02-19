local common = require("OperatorJack.Vampyr.common")

---@class Vampyr.Embrace
local this = {}

---Embraces reference and turns them into a vampire.
---Similar the the player, the NPC must go three days without being treated for
---Porphyric_Hemophilia. Then, they become a vampire.
---This function sets up the data necessary for regular event handlers to complete the process.
---@param reference tes3reference
this.embraceTarget = function(reference)
    -- @TODO: Implement
end

---Target embraces player and turns them into a vampire. (just contracts Porphyric_Hemophilia. Then, they become a vampire)
---This function sets up the data necessary for regular event handlers to complete the process.
---@param reference tes3reference
this.embraceByTarget = function(reference)
    -- @TODO: Implement
end

return this
