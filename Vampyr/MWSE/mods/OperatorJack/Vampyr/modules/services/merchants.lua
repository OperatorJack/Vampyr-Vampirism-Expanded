local common = require("OperatorJack.Vampyr.common")

--- Place an invisible, appCulled container at the feet of a merchant and assign ownership.
--- This is how we add stock to merchants without editing the cell in the CS
local function placeContainer(merchant, containerId)
    common.logger.debug("Adding container %s to %s", containerId, merchant.object.id)
    local container = tes3.createReference {
        object = containerId,
        position = merchant.position:copy(),
        orientation = merchant.orientation:copy(),
        cell = merchant.cell
    }
    tes3.setOwner { reference = container, owner = merchant }
end

local bloodVialObjectTypes = {
    [tes3.objectType.ingredient] = true,
    [tes3.objectType.alchemy] = true,
}

---@param e mobileActivatedEventData
local function onMobileActivated(e)
    if e.reference and
        e.reference.mobile and
        common.isVampireMerchant(e.reference, bloodVialObjectTypes) == true then
        local added = e.reference.data.vampyrGearAdded == true
        if not added then
            e.reference.data.vampyrGearAdded = true
            placeContainer(e.reference, common.ids.containers.merchant)
        end
    end
end
event.register(tes3.event.mobileActivated, onMobileActivated)
