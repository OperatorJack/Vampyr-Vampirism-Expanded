local config = require("OperatorJack.Vampyr.config")

local function createTableVar(id)
    return mwse.mcm.createTableVariable{ id = id, table = config }
end

local function getNpcs()
    local temp = {}
    for obj in tes3.iterateObjects(tes3.objectType.npc) do
        temp[obj.id] = true
    end

    local list = {}
    for id in pairs(temp) do
        list[#list+1] = id
    end

    table.sort(list)
    return list
end

local function getWeapons()
    local temp = {}
    for obj in tes3.iterateObjects(tes3.objectType.weapon) do
        temp[obj.id] = true
    end

    local list = {}
    for id in pairs(temp) do
        list[#list+1] = id
    end

    table.sort(list)
    return list
end

local function createGeneralCategory(page)
    local category = page:createCategory{
        label = "General Settings"
    }

    -- Create option to capture debug mode. Set log level.

    category:createDropdown{
        label = "Log Level",
        description = "Set the logging level for mwse.log. Keep on INFO unless you are debugging. TRACE = Maximum detail. This will generate HUGE log files. DEBUG = High detail. Enable this when troubleshooting. INFO = standard information. ERROR = only errors. NONE = no logs.",
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        variable = createTableVar("logLevel"),
    }

    return category
end

local function createUICategory(page)
    local category = page:createCategory{
        label = "User Interface Settings"
    }

    -- Create option to capture debug mode.
    category:createOnOffButton{
        label = "Blood Fillbar On Top",
        description = "If enabled, the blood fillbar will appear above the health fillbar in the HUD and Stats Menu. Otherwise, it will appear below stamina. Game restart required.",
        variable = createTableVar("uiBloodFillbarOnTop"),
        restartRequired = true
    }

    return category
end

local function createShadowStepSettings(category)
    category:createKeyBinder{
        label = "Assign Keybind for entering and confirming Shadowstep",
        description = "Use this option to set the hotkey for Shadowstep. Click on the option and follow the prompt. This key will start Shadowstep as well as confirm the action.",
        allowCombinations = true,
        variable = createTableVar("shadowStepActionKey"),
    }

    category:createKeyBinder{
        label = "Assign Keybind for exiting Shadowstep",
        description = "Use this option to set the hotkey for exiting Shadowstep. Click on the option and follow the prompt. This key will exit Shadwstep if you are in Shadowstep mode.",
        allowCombinations = true,
        variable = createTableVar("shadowStepCancelKey"),
    }
end

local function createClawsSettings(category)
    category:createSlider{
        label = "Claws Blood Draw Base Chance",
        description = "The base chance per claw attack of drawing blood. Can be increased to make blood draw happen more often.",
        min = 0,
        max = 100,
        step = 1,
        jump = 5,
        variable = createTableVar("clawsBaseChance"),
    }
end

local function createMechanicCategory(page)
    local category = page:createCategory{
        label = "Mechanic Settings"
    }

    createShadowStepSettings(category)
    createClawsSettings(category)
end


local function createAshfallSettings(category)
    -- Create option to capture debug mode.
    category:createOnOffButton{
        label = "Enable Ashfall Integrations",
        description = "If enabled and Ashfall is installed, Ashfall calculations for sunlight and coverage will be used instead of Vampyr calculations. Game restart required.",
        variable = createTableVar("enableAshfallIntegration"),
        restartRequired = true
    }
end

local function createIntegrationsCategory(page)
    local category = page:createCategory{
        label = "Integrations Settings"
    }

    createAshfallSettings(category)
end

local function createGeneralPage(template)
    local page = template:createSideBarPage{
        label = "General Settings",
        description = "Hover over a setting to learn more about it."
    }

    createGeneralCategory(page)
    createUICategory(page)
    createMechanicCategory(page)
    createIntegrationsCategory(page)
end

local function createFakeNPCVampireList(template)
    template:createExclusionsPage{
        label = "Fake NPC Vampires",
        description = "NPCs registered as a fake NPC Vampire will have the vampirism disease added to them, and thereafter be treated by the game as real vampires. This tool is used to fix issues where `vampires` do not have the vampirism disease in the base game or in mods. This will not update NPCs that you have already met in a current save game, and it requires a restart after making changes.",
        leftListLabel = "Fake NPC Vampires",
        rightListLabel = "All NPCs",
        variable = createTableVar("fakeNpcVampires"),
        filters = {
            {callback = getNpcs},
        },
    }
end

local function createStakeList(template)
    template:createExclusionsPage{
        label = "Stakes",
        description = "Weapons registered as a stake will be used by NPCs to fight vampires, even above higher tier weapons.",
        leftListLabel = "Stakes",
        rightListLabel = "All Weapons",
        variable = createTableVar("stakes"),
        filters = {
            {callback = getWeapons},
        },
    }
end

-- Handle mod config menu.
local template = mwse.mcm.createTemplate("Vampyr")
template:saveOnClose("Vampyr", config)

createGeneralPage(template)
createFakeNPCVampireList(template)
createStakeList(template)

mwse.mcm.register(template)