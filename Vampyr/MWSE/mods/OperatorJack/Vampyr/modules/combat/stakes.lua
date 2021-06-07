local config = require("OperatorJack.Vampyr.config")
local common = require("OperatorJack.Vampyr.common")

local function onDeterminedAction(e)
    local session = e.session
    local mobile = session.mobile
    local target = mobile.actionData.target

    if (target) then
        if (common.isReferenceVampire(target.reference) == true) then

            -- get stake
            local stake
            for _, stack in pairs(mobile.reference.object.inventory) do
                if (config.stakes[stack.object.id]) then
                    stake = stack.object
                    break
                end
            end

            if (stake == nil) then
                return
            end

            if (mobile.readiedWeapon and mobile.readiedWeapon.object == stake) then
                return false
            end

            -- equip stake.
            timer.delayOneFrame(function()
                mobile:equip(stake)
            end)

            return false
        end
    end
end
event.register("determinedAction", onDeterminedAction)