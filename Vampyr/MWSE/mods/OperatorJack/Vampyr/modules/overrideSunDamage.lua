local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood")

local vfxNode

local function getOrAttachVfx(reference)
    local node, sceneNode
    sceneNode = reference.sceneNode
    node = sceneNode:getObjectByName("OJ_V_SunDamageVfx")

    if (not node) then
        vfxNode = vfxNode or tes3.loadMesh(common.paths.sunDamageVfx)
        node = vfxNode:clone()

        if (reference.object.race) then
            if (reference.object.race.weight and reference.object.race.height) then
            local weight = reference.object.race.weight.male
            local height = reference.object.race.height.male
            if (reference.object.female == true) then
                weight = reference.object.race.weight.female
                height = reference.object.race.height.female
            end

            local weightMod = 1 / weight
            local heightMod = 1/ height

            local r = node.rotation
            local s = tes3vector3.new(weightMod, weightMod, heightMod)
            node.rotation = tes3matrix33.new(r.x * s, r.y * s, r.z * s)
            end
        end

        sceneNode:attachChild(node, true)
        sceneNode:update()
        sceneNode:updateNodeEffects()
    end

    return node
end

local function showNode(node)
    if (node.appCulled == true) then
        node.appCulled = false
    end
end

local function hideNode(node)
    if (node.appCulled == false) then
        node.appCulled = true
    end
end

local function getShaderModifier(reference)
    if (reference.cell.isInterior == true and reference.cell.behaveAsExterior ~= true) then
        return 0
    end

    return 1
end

local function SunDamage(mobile, attributeVariant, sourceInstance, deltaTime, magic_effect_instance, effect_index)
    local target = mobile.reference
    local resistanceMagnitude = tes3.getEffectMagnitude({
        reference = target,
        effect = tes3.effect.resistSunDamage
    }) or 0

    local resistanceModifier = 1 - (resistanceMagnitude / 100)

    -- Calculate damage for reference, taking into account location, weather, shade, etc.
    local shadeModifier = getShaderModifier(target)
    local damage = shadeModifier * resistanceModifier * attributeVariant

    if (target == tes3.player) then
        --common.debug(string.format("Sun Damage: shade: %s, resist: %s, attrib: %s = damage: %s", shadeModifier, resistanceModifier, attributeVariant, damage))
    end


    local node = getOrAttachVfx(target)
    if math.abs(damage) > 0.001 then
        showNode(node)

        if (blood.isInitialized(target) == true) then
            local bloodAmount = 1.0 * attributeVariant
            local currentBloodAmount = blood.getReferenceBloodStatistic(target).current

            -- Blood amount will be negative.
            local bloodRemainder = currentBloodAmount + bloodAmount

            blood.modReferenceCurrentBloodStatistic(target, bloodAmount, true)

            if bloodRemainder <= 0 then
                -- Convert to positive and decrease by 50%.
                local healthAmount = bloodRemainder * 0.5 * -1
                target.mobile:applyHealthDamage(healthAmount)
            end
        end
    else
        hideNode(node)
    end

    return damage
end

-- The section of code we want to overwrite is [0x464c09, 0x464c29)
-- This effectively replaces the call to calculate the sun damage scalar, and the subsequent multiplication of attributeVariant by the scalar.
-- attributeVariant = -0x4 // location of attributeVariant on the stack
-- Get the target of the effect.
mwse.memory.writeBytes({ address = 0x464c09, bytes = { 0xe8, 0x42, 0x0b, 0x08, 0x00 } }) -- call game_getRefrDataActor (0x4e5750)
-- Copy the effect target to the esi register. Other code later expects it to be there.
mwse.memory.writeBytes({ address = 0x464c0e, bytes = { 0x8b, 0xf0 } }) -- mov esi, eax
-- Copy the current value of attributeVariant to the eax register so that we can push it onto the stack.
mwse.memory.writeBytes({ address = 0x464c10, bytes = { 0x8b, 0x44, 0x24, 0x30 } }) -- mov eax, [esp+0x34+attributeVariant]
-- Push attributeVariant onto the stack.
mwse.memory.writeByte({ address = 0x464c14, byte = 0x50 }) -- push eax
-- Push the effect target onto the stack.
mwse.memory.writeByte({ address = 0x464c15, byte = 0x56 }) -- push esi
-- Call our custom lua function.
mwse.memory.writeFunctionCall({
    address = 0x464c16,
    call = SunDamage,
    signature = {
        arguments = { 'tes3mobileObject', 'float', 'tes3object', 'float', 'tes3magicEffectInstance', 'uint' },
        returns = 'float'
    }
})
-- Clean up the stack. The custom lua function has already cleaned up its arguments; clean up the rest.
mwse.memory.writeBytes({ address = 0x464c1b, bytes = { 0x83, 0xc4, 0x18 }}) -- add esp 0x18
-- Copy the return value of the custom lua function to attributeVariant.
mwse.memory.writeBytes({ address = 0x464c1e, bytes = { 0x89, 0x44, 0x24, 0x08 } }) -- mov [esp+0xc+attributeVariant], eax
-- Load the value of attributeVariant onto the fpu stack, so that the game can use it for subsequent comparisons.
mwse.memory.writeBytes({ address = 0x464c22, bytes = { 0xd9, 0x44, 0x24, 0x08 } }) -- fld [esp+0xc+attributeVariant]
-- Overwrite the rest of this section with no op.
mwse.memory.writeNoOperation({ address = 0x464c26, length = 0x3 })