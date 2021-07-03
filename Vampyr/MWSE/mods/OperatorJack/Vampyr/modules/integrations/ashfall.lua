local ashfall = include("mer.ashfall.interop")
if ashfall then
    local common = require("OperatorJack.Vampyr.common")

    if not common.config.enableAshfallIntegration == true then return end

    -- Integrate shade mechanics for player.
    event.register(common.events.calcSunDamageModifiers, function(e)
        if e.target == tes3.player then
            e.shade = ashfall.getSunlightNormalized()
        end
    end)
end