local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency")
local bloodSpells = require("OperatorJack.Vampyr.modules.blood-spells")

local UP = tes3vector3.new(0,0,1)
local ID33 = tes3matrix33.new(1,0,0,0,1,0,0,0,1)


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
            mwscript.setDelete{ reference = markerReference}
            markerReference = nil
        end)
    end
end

local function markerSimulate(e)
    if (markerReference == nil) then
        local markerObject = tes3.getObject("VAMPYR_ShadowStepMarker")

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
        tes3.messageBox("You do not have enough blood remaining to shadowstep to that position.")

    else
        bloodSpells.applyBloodMagicCostForPlayer(cost)

        tes3.playSound({
            sound = "mysticism hit",
            reference = tes3.player
        })

        local teleObject = tes3.getObject("VAMPYR_ShadowTeleMarker") or tes3static.create({
            id="VAMPYR_ShadowTeleMarker",
            mesh="VAMPYR\\widget_teleport.nif"}
        )

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
            callback = function ()

                if (teleReference) then
                    teleReference:disable()
                    timer.delayOneFrame(function()
                        mwscript.setDelete{ reference = teleReference}
                        teleReference = nil
                    end)
                end
            end
        })
    end

    removeMarker()
end

local function shadowStepKey(e)
    if (common.isPlayerVampire() == false) then return end
    if (bloodPotency.getLevel(tes3.player) < 4) then
        tes3.messageBox("You are not powerful enough to shadowstep yet.")
        return
    end

    if (isInShadowStepMode == false) then
        enterShadowStepMode()
    elseif (isInShadowStepMode == true and e.isAltDown == true) then
        exitShadowStepMode()
    elseif (isInShadowStepMode == true and e.isAltDown == false) then
        confirmShadowStep()
    end
end
event.register("keyDown", shadowStepKey, { filter = tes3.scanCode.z })