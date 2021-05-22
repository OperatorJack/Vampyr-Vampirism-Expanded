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

local function playerVampireStateChanged(e)
    if (e.isVampire == true) then
        setAnimation(tes3.player)
    end
end
event.register(common.events.playerVampireStateChanged, playerVampireStateChanged)

event.regsiter("loaded", function(e)
    if common.isPlayerVampire() == true then
        setAnimation(tes3.player)
    end
end)

event.regsiter("mobileActivated", function(e)
    if common.isReferenceVampire(e.reference) == true then
        setAnimation(e.reference)
    end
end)