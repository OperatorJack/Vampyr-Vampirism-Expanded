local common = require("OperatorJack.Vampyr.common")

local function setAnimation(ref)
    if ref == tes3.player then
        tes3.loadAnimation({
            reference = tes3.player1stPerson,
            file = "base_animkna.1st.nif",
        })
    end

    tes3.loadAnimation({
        reference = ref,
        file = "base_animkna.nif",
    })
end

-- Set Animations
local function playerVampireStateChanged(e)
    if (e.isVampire == true) then
        setAnimation(tes3.player)
    end
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

event.register("loaded", function(e)
    if common.isPlayerVampire() == true then
        setAnimation(tes3.player)
    end
end)

event.register("referenceActivated", function(e)
    if not e.reference then return end
    if common.isReferenceVampire(e.reference) == true then
        setAnimation(e.reference)
    end
end)

-- Handle Claws mechanics
event.register("damage", function(e)
    tes3.messageBox("Attacking with claws! %s")

    if not e.attackerReference then return end
    if common.isReferenceVampire(e.attackerReference) == false then return end
    if e.attackerReference.readiedWeapon then return end
    if e.magicSourceInstance then return end
    if e.project then return end

    common.debug("Attacking with claws! %s", e.attackerReference.readiedWeapon)



end)