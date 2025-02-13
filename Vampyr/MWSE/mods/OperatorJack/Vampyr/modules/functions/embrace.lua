local common = require("OperatorJack.Vampyr.common")

local exports = {}

exports.embraceTarget = function(reference)
    -- Embrace reference and turn them into a vampire.
    -- Similar the the player, the NPC must go three days without being treated for
    -- Porphyric_Hemophilia. Then, they become a vampire.
    -- This function sets up the data necessary for regular event handlers to complete the process.

    -- @TODO: Implement
end

exports.embraceByTarget = function(reference)
    -- Target embraces player and turns them into a vampire. (just contracts P orphyric_Hemophilia. Then, they become a vampire)
    -- This function sets up the data necessary for regular event handlers to complete the process.

    -- @TODO: Implement
end

return exports
