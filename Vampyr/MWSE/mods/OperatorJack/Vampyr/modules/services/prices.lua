local common = require("OperatorJack.Vampyr.common")
local blood = require("OperatorJack.Vampyr.modules.blood-module.blood")
local bloodPotency = require("OperatorJack.Vampyr.modules.blood-potency-module.blood-potency")


local function calcItemDataPrice(e)
    if not e.reference then return end
    if not common.isPlayerVampire() == true then return end
    if not common.isReferenceVampire(e.reference) == true then return end
    if not common.isSerum(e.item.id) == true then return end

    local price = e.price

    -- Faction multipler amount
    local factionMod = 0
    if e.mobile.object.faction then
        local faction = e.mobile.object.faction.id
        local isVampireFaction = common.isVampireFaction(faction)
        if (isVampireFaction) then
            local rank = e.mobile.object.factionRank
            local playerRank = tes3.getFaction(faction).playerRank
            if (rank and playerRank) then
                factionMod = (price * 0.25 * (rank - playerRank)) -- If player is higher rank, discount
            end
        end
    end

    -- Blood Thirst multiplier -- TODO
    local currentBlood = blood.getPlayerBloodStatistic()
    local normalizedBlood = currentBlood.current / currentBlood.base
    local bloodThirstMod = price * (1 - normalizedBlood) - price

    -- Potency Discount
    local level = bloodPotency.getLevel(tes3.player)
    local npcLevel = bloodPotency.getLevel(e.reference)
    local normalizedLevel = npcLevel / level
    local potencyMod = price * .25 * normalizedLevel

    -- Total up
    price = price + factionMod + bloodThirstMod + potencyMod

    common.logger.debug("Blood Serum Price: %s || %s", e.price, price)
    e.price = math.max(1, price)
end
event.register("calcBarterPrice", calcItemDataPrice)