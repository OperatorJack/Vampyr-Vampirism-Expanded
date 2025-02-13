local common = require("OperatorJack.Vampyr.common")

-- Override PCVampire dialogue filter function.
local function isPcVampire()
    local isVampire = common.isPlayerVampire()

    -- Trigger event for other modules to modify sun damage if needed.
    local params = { isVampire = isVampire }
    event.trigger(common.events.dialogueFilterPcVampire, params)
    isVampire = params.isVampire

    if isVampire == true then return 1 else return 0 end
end -- Return 1 for vampire, 0 for totally not a vampire

mwse.memory.writeFunctionCall { address = 0x4B1018, length = 0xE, call = isPcVampire, signature = { returns = "int" } }
mwse.memory.writeBytes { address = 0x4B101D, bytes = { 0x50, 0xDB, 0x44, 0x24, 0x00, 0x58 } }
mwse.memory.writeBytes { address = 0x4B102C, bytes = { 0xE9, 0xCF, 0x04, 0, 0 } }
