local class = {}

function class.isPositionInShadow(position)
    if (tes3.player.cell.isInterior and not tes3.player.cell.behaveAsExterior) then
        return true
    end

    local hour = tes3.worldController.hour.value
    if (hour < 4 or hour > 20)then
        return true
    end

    local sunPos = tes3.worldController.weatherController.sceneSunBase.worldTransform.translation
    local sunLightDirection = (sunPos - position):normalized()
    local result = tes3.rayTest({
        position = position,
        direction = sunLightDirection,
        ignore = { tes3.player }
    })
    if (result) then
        return true
    end

    return false
end

function class.getNormalizedShadeModifier(reference)
    -- Detect interior cell.
    if reference.cell.isInterior == true and reference.cell.behaveAsExterior ~= true then
        return 0
    end

    -- Detect app culled sky... IDK, vanilla does it.
    local weatherController = tes3.worldController.weatherController
    if weatherController.sceneSkyRoot.appCulled == true then
        return 0
    end

    local weather = weatherController.currentWeather
    local hour = tes3.worldController.hour.value
    local sunRisen = 1

    if hour > weatherController.sunriseHour
       and hour < weatherController.sunriseDuration + weatherController.sunriseHour then
        sunRisen = (hour - weatherController.sunriseHour) / weatherController.sunriseDuration
    end

    if hour > weatherController.sunsetHour
       and hour <= weatherController.sunsetDuration + weatherController.sunsetHour then
        sunRisen = 1 - (hour - weatherController.sunsetHour) / weatherController.sunsetDuration
    end

    if hour > weatherController.sunriseDuration + weatherController.sunriseHour
       and hour <= weatherController.sunsetHour then
        sunRisen = 1
    end

    if hour > weatherController.sunsetDuration + weatherController.sunsetHour
       or hour <= weatherController.sunriseHour then
        sunRisen = 0
    end

    local sunVisibility = weather.glareView
    if weatherController.transitionScalar ~= 0.0 then
        local nextWeather = weatherController.nextWeather

        if nextWeather.cloudsMaxPercent >= weatherController.transitionScalar then
            local t = weatherController.transitionScalar / nextWeather.cloudsMaxPercent
            sunVisibility = (1 - t) * weatherController.currentWeather.glareView + t * nextWeather.glareView
        else
            sunVisibility = nextWeather.glareView
        end
    end

    -- All weather has a 0.10 base visibility percentage. Sorry Todd!
    sunVisibility = sunVisibility + 0.1

    return math.clamp(sunVisibility * sunRisen, 0, 1)
end

return class