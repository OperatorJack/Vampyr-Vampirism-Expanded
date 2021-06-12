local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")
local nodeManager = require("OperatorJack.Vampyr.modules.functions.node-manager")

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
        --common.logger.trace("Sun Damage: shade: %s, resist: %s, attrib: %s = damage: %s", shadeModifier, resistanceModifier, attributeVariant, damage)
    end

    local params = { reference = target, damage = damage}
    event.trigger(common.events.calcSunDamage, params)
    damage = params.damage

    local node = nodeManager.getOrAttachVfx(target, "OJ_V_SunDamageVfx", common.paths.sunDamageVfx)
    if math.abs(damage) > 0.001 then
        nodeManager.showNode(node)

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
        nodeManager.hideNode(node)
    end

    -- Bypass vanilla sun damage function by returning 0 damage.
    return 0
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