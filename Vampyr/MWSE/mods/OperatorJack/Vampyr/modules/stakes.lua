local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")

local function onDeterminedAction(e)
    local session = e.session
    local mobile = session.mobile
    local target = mobile.actionData.target

    if (target) then
        if (common.isReferenceVampire(target.reference) == true) then
            common.debug("Target is vampire!")

            -- get stake
            local stake
            for _, stack in pairs(mobile.reference.object.inventory) do
                if (config.stakes[stack.object.id]) then
                    common.debug("Mobile has stake!")
                    stake = stack.object
                end
            end

            if (stake == nil) then
                return
            end


            -- equip stake.
            timer.delayOneFrame(function()
                mobile:equip(stake)
            end)
        end
    end
end
event.register("determineAction", onDeterminedAction)