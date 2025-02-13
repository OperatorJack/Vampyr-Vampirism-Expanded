local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency")
local bloodSpells = require("OperatorJack.Vampyr.modules.blood-spells-module.blood-spells")

local UP = tes3vector3.new(0, 0, 1)
local ID33 = tes3matrix33.new(1, 0, 0, 0, 1, 0, 0, 0, 1)


local function rotation_difference(vec1, vec2)
    vec1 = vec1:normalized()
    vec2 = vec2:normalized()

    local axis = vec1:cross(vec2)
    local norm = axis:length()
    if norm < 1e-5 then
        return ID33
    end

    local angle = math.asin(norm)
    if vec1:dot(vec2) < 0 then
        angle = math.pi - angle
    end

    axis:normalize()

    local m = ID33:copy()
    m:toRotation(-angle, axis.x, axis.y, axis.z)
    return m
end


local isInShadowStepMode = false
local markerReference
local markerLastPositionCheck

local function removeMarker()
    if (markerReference) then
        markerReference:disable()
        timer.delayOneFrame(function()
            mwscript.setDelete { reference = markerReference }
            markerReference.modified = false
            markerReference = nil
        end)
    end
end

local function markerSimulate(e)
    if (markerReference == nil) then
        local markerObject = tes3.getObject(common.ids.shadowstep.marker)

        markerReference = tes3.createReference({
            object = markerObject,
            position = tes3.player.position,
            cell = tes3.player.cell
        })
        markerReference.modified = false
        markerLastPositionCheck = nil
    end

    markerReference:setDynamicLighting()

    local eyevec = tes3.getPlayerEyeVector()
    local eyepos = tes3.getPlayerEyePosition()
    local rayhit = tes3.rayTest({
        position = eyepos,
        direction = eyevec,
        ignore = {
            tes3.player,
            markerReference
        }
    })
    if rayhit then
        markerReference.position = rayhit.intersection
        if (markerLastPositionCheck == nil or markerReference.position:distance(markerLastPositionCheck) >= 10) then
            markerLastPositionCheck = markerReference.position:copy()
        end
    end
end

local function enterShadowStepMode()
    event.register("simulate", markerSimulate)
    isInShadowStepMode = true
end

local function exitShadowStepMode()
    event.unregister("simulate", markerSimulate)
    isInShadowStepMode = false

    removeMarker()
end

local function confirmShadowStep()
    event.unregister("simulate", markerSimulate)
    isInShadowStepMode = false

    local modifier = bloodSpells.getBloodMagicCostModifierForPlayer()
    local cost = (markerReference.position:distance(tes3.player.position) / 50 + 5) * modifier

    if (blood.getPlayerBloodStatistic().current < cost) then
        tes3.messageBox(common.text.shadowstepFailed_TooFar)
    else
        bloodSpells.applyBloodMagicCostForPlayer(cost)

        tes3.playSound({
            sound = "mysticism hit",
            reference = tes3.player
        })

        local teleObject = tes3.getObject(common.ids.shadowstep.circle)

        local teleReference = tes3.createReference({
            object = teleObject,
            position = markerReference.position,
            cell = markerReference.cell
        })
        teleReference.modified = false

        tes3.positionCell({
            reference = tes3.player,
            position = markerReference.position,
            cell = markerReference.cell
        })

        timer.start({
            duration = 2,
            callback = function()
                if (teleReference) then
                    teleReference:disable()
                    timer.delayOneFrame(function()
                        mwscript.setDelete { reference = teleReference }
                        teleReference.modified = false
                        teleReference = nil
                    end)
                end
            end
        })
    end

    removeMarker()
end


local function shadowStepKey(e)
    if not tes3.player then return end
    if tes3.isKeyEqual({ actual = e, expected = common.config.shadowStepActionKey }) == true then
        common.logger.debug("Detected Shadowstep action key.")

        if common.isPlayerVampire() == false then return end
        if bloodPotency.getLevel(tes3.player) < 4 then
            tes3.messageBox(common.text.shadowstepFailed_TooWeak)
            return
        end

        if isInShadowStepMode == false then
            common.logger.trace("Entering Shadowstep mode.")
            enterShadowStepMode()
        else
            common.logger.trace("Confirming Shadowstep.")
            confirmShadowStep()
        end
    end
    if tes3.isKeyEqual({ actual = e, expected = common.config.shadowStepCancelKey }) == true and isInShadowStepMode == true then
        common.logger.trace("Detected Shadowstep cancel key while in shadowstep mode. Exitting Shadowstep.")
        exitShadowStepMode()
    end
end
event.register("keyDown", shadowStepKey)
