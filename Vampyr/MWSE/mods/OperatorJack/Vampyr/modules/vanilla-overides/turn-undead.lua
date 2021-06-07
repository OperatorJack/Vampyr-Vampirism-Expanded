local common = require("OperatorJack.Vampyr.common")

local function IsValidTurnUndeadTarget(target)
    local result = false
    if target.actorType == tes3.actorType.creature then
        result = target.object.baseObject.type == tes3.creatureType.undead
    elseif target.actorType == tes3.actorType.npc then
        result = common.isReferenceVampire(target.reference) == true
    end

    common.logger.trace("Overriding Vanilla Turn Undead logic. %s is undead = %s.", target, result)

    return result
end

-- Change the game code to call our custom function to check target validity when applying the Turn Undead effect to an actor.
-- The section of code we want to modify is [0x4631cf, 0x463217).
-- Push target onto the stack.
mwse.memory.writeByte({ address = 0x4631cf, byte = 0x50 }) -- push eax
mwse.memory.writeFunctionCall({
    address = 0x4631d0,
    call = IsValidTurnUndeadTarget,
    signature = {
        arguments = { 'tes3mobileObject' },
        returns = 'bool'
    }
})
-- Is the target valid?
mwse.memory.writeBytes({ address = 0x4631d5, bytes = { 0x85, 0xc0 } }) -- test eax, eax
-- If it is, jump to spell effect procssing.
mwse.memory.writeBytes({ address = 0x4631d7, bytes = { 0x75, 0x3e } }) -- jnz 0x463217
-- If not, retire the effect.
mwse.memory.writeBytes({ address = 0x4641d9, bytes = { 0xc7, 0x47, 0x14, 0x07, 0x00, 0x00, 0x00 } }) -- mov dword ptr [edi+0x14], 7
-- Restore registers and return.
mwse.memory.writeByte({ address = 0x4631e0, byte = 0x5f }) -- pop edi
mwse.memory.writeByte({ address = 0x4631e1, byte = 0x5e }) -- pop esi
mwse.memory.writeByte({ address = 0x4631e2, byte = 0xc3 }) -- retn
-- Overwrite the rest of this section with no op.
mwse.memory.writeNoOperation({ address = 0x4631e3, length = 0x34 })