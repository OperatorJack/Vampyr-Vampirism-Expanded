-- Load configuration.
return mwse.loadConfig("Vampyr", {
    -- Initialize Settings
    debug = true,
    uiBloodFillbarOnTop = true,

    clawsBaseChance = 10,

    shadowStepKey = {
        keyCode = tes3.scanCode.z,
        isShiftDown = false,
        isAltDown = false,
        isControlDown = false,
    },
    fakeNpcVampires = {
        ["raxle berne"] = true,
        ["dhaunayne aundae"] = true,
        ["volrina quarra"] = true,
        ["areas"] = true,
        ["igna"] = true,
        ["siri"] = true,
        ["mororurg"] = true,
        ["moranarg"] = true,
        ["gladroon"] = true,
        ["tarerane"] = true,
        ["lorurmend"] = true,
        ["mirkrand"] = true,
        ["iroroon"] = true,
        ["tragrim"] = true,
        ["pelf"] = true,
        ["kjeld"] = true,
        ["knurguri"] = true,
        ["gergio"] = true,
        ["leone"] = true,
        ["germia"] = true,
        ["arenara"] = true,
        ["eloe"] = true,
        ["clasomo"] = true,
        ["ildogesto"] = true,
        ["fammana"] = true,
        ["reberio"] = true,
        ["calvario"] = true,
        ["myn farr"] = true,
    },
    stakes = {
        ["OJ_V_WoodenStake"] = true,
        ["OJ_V_SteelStake"] = true,
        ["OJ_V_SilverStake"] = true,
    }
})
