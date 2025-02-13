local bodyPartBlacklist = {
    [tes3.activeBodyPart.groin] = true,
    [tes3.activeBodyPart.hair] = true,
    [tes3.activeBodyPart.leftPauldron] = true,
    [tes3.activeBodyPart.rightPauldron] = true,
    [tes3.activeBodyPart.shield] = true,
    [tes3.activeBodyPart.skirt] = true,
    [tes3.activeBodyPart.tail] = true,
    [tes3.activeBodyPart.weapon] = true,
}

local class = {}

local activeBodyPartCount
local function getCountActiveBodyParts()
    if activeBodyPartCount then
        return activeBodyPartCount
    end

    activeBodyPartCount = 0
    for _ in pairs(tes3.activeBodyPart) do
        activeBodyPartCount = activeBodyPartCount + 1
    end

    return activeBodyPartCount
end

local blacklistBodyPartCount
local function getCountBlacklistBodyParts()
    if blacklistBodyPartCount then
        return blacklistBodyPartCount
    end

    blacklistBodyPartCount = 0
    for _ in pairs(bodyPartBlacklist) do
        blacklistBodyPartCount = blacklistBodyPartCount + 1
    end

    return blacklistBodyPartCount
end

local function getExposedBodyParts(ref)
    return coroutine.wrap(function()
        for name, index in pairs(tes3.activeBodyPart) do
            if not bodyPartBlacklist[index] then
                local bodyPart = ref.bodyPartManager:getActiveBodyPart(tes3.activeBodyPartLayer.base, index)
                if bodyPart and bodyPart.node then
                    coroutine.yield(index, name)
                end
            end
        end
    end)
end

function class.getNormalizedSkinExposureModifier(reference)
    local exposed = 0
    for _, name in getExposedBodyParts(reference) do
        exposed = exposed + 1
    end
    local numberBodyParts = getCountActiveBodyParts() - getCountBlacklistBodyParts()
    local modifier = exposed / numberBodyParts

    return modifier
end

return class
