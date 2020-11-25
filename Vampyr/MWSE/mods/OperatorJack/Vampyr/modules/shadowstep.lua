local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency")

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
local function markerSimulate(e)
    if (markerReference == nil) then
        local markerObject = tes3.getObject("VAMPYR_ShadowStepMarker") or tes3static.create({
            id="VAMPYR_ShadowStepMarker", 
            mesh="VAMPYR\\widget_circle.nif"}
        )

        markerReference = tes3.createReference({
            object = markerObject, 
            position = tes3.player.position, 
            cell = tes3.player.cell
        })
        markerLastPositionCheck = nil
    end

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
        markerReference.orientation = rotation_difference(UP, rayhit.normal)

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

    if (markerReference) then
        markerReference:disable()
        markerReference = nil
    end
end

local function confirmShadowStep()
    event.unregister("simulate", markerSimulate)
    isInShadowStepMode = false

    local bloodPotencyLevel = bloodPotency.getLevel(tes3.player)
    local modifier = (10 - bloodPotencyLevel) / 11
    local cost = (markerReference.position:distance(tes3.player.position) / 50 + 5) * modifier

    if (blood.getPlayerBloodStatistic().current < cost) then
        tes3.messageBox("You do not have enough blood remaining to shadowstep to that position.")

    else
        blood.modPlayerCurrentBloodStatistic(cost * -1)

        tes3.playSound({
            sound = "mysticism hit",
            reference = tes3.player
        })
        
        tes3.positionCell({
            reference = tes3.player,
            position = markerReference.position,
            cell = tes3.player.cell
        })
    end

    if (markerReference) then
        markerReference:disable()
        markerReference = nil
    end
end

local function shadowStepKey(e)
    if (common.isPlayerVampire() == false) then return end
    if (bloodPotency.getLevel(tes3.player) < 4) then
        tes3.messageBox("You are not powerful enough to shadowstep yet.")
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