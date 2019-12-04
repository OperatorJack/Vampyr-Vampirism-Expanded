# Vampyr: Vampirism Expanded
Vampyr: Vampirism Expanded mod for TES III: Morrowind

## Description
Expands Vampirism in TES III: Morrowind by adding new mechanics, new spells, new items, and more for Vampires. At a cursory glance, these new mechanics are inspired by, but not limited to, the vampire mechanics found in the game *Vampyr*. Similar mechanics include blood statistics, serums, and some spells.

## Mechanics

### **Blood**   
The first and main new mechanic is the addition of a new player statistic to accompany *Health*, *Magicka*, and *Stamina* for vampires. This new statistic is called *Blood*. Visually, this new statistic will appear below *Stamina* in the HUD and player menu as a 4th, blood-red statistic bar. 

When transformed into a vampire, this new statistic will become available to the player. The base blood value at the time of the transformation will be calculated using the following formula, subject to change:
```lua
local willpower = tes3.mobilePlayer.willpower.base
local endurance = tes3.mobilePlayer.endurance.base
local base = (endurance / 10.0) + 5^(willpower / 40.0)
```

The current blood value at the time of transformation will be **1**. This means that the player will start with **1 out of *base*** blood.

Unlike the other statistics, resting will not recover blood. Blood can only be restored via the actions outlined below. Blood degrades at an exponential rate as days pass without restoring blood. This means that for each day that passes, the player's blood level will decrease by an increasing amount. The blood degradation rate will be calculated using the following formula, subject to change:
```lua
local modAmount = -1 * (1.2 ^ daysPassed) - 20
```

If the blood level reaches 0, the player will begin losing health at 1pt per second, increasing exponentially, until blood is increased above 0.

Blood can be restored via feeding and blood serums (restore blood effect potions).

Blood base amount can be permanently increased by levelling up, similarly to how Magicka is increased. The governing attributes are endurance and willpower. The previous formula to calculate the base amount will be reused to calculate the new base amount.

Blood can be consumed to use vampiric powers, spells and other special abilities, outlined below.

All NPCs will show the amount of blood you get per feeding as part of their UI tooltip. The amount of blood you get per feeding is calculated based on their level and attributes, using this formula:
```lua
local bloodAmount = 50 + level - (endurance/10) - (willpower/10)
```

### **Blood Magic**   
Blood can be consumed to perform a new type of magic, blood magic. Blood magic functions similarly to regular magic, but costs blood instead of magicka. Blood magic centers around destruction and illusion type spells. 

Intended spell effects include: 
- Restore Blood
- Drain Blood
- Damage Blood
- Fortify Blood
- Weakness to Blood
- Mirage

### **Shadowstep**
When in shadows, the player will have the ability to teleport to any visible location that is also in shadows. This will be mappd to a new key button. This will cost 25 blood per use. Teleporting to a non-shadow area by accident will still consume 25 blood, but no teleport will occur.

### **Feeding**   
A new service option will be added to all NPC dialogue windows: "Feeding". Using this service option will perform a success-check. If successful, the player will feed on the NPC and gain a calculated blood amount. If failed, the NPC will report the player for assault and flee. A successful feeding increases disposition by a small amount. The feeding success state and timestamp will be saved to for the NPC for later usage. The following formula will be used for the success-check:
```lua
local function Calc(mobile)
   local luck = mobile.luck.current
   if (luck > 100) then luck = 100 end

   local modifier = 0
    if (isMesmerized) then modifier = 20 end

   return mobile.willpower.current + mobile.endurance.current + random(luck,100) * .10 - modifier
end

local playerCalc = Calc(tes3.mobilePlayer)
local npcCalc = Calc(npc.mobile)
return playerCalc >= npcCalc
```

If feeding occurs, the NPC's health will be drained by twice the amount of blood received.

### **Mesmerize**   
A new service option will be added to all NPC dialogue windows: "Mesmerize". Using this service option will perform a success-check. If successful, the NPC will be pacified and follow the player for a calculated amount of time. The calculated amount of time is based on the player's willpower and the NPC's willpower. At the end of the calculated amount of time, a success-check will be performed. If succesful, the NPC will have their disposition slightly increased. If failed, the NPC will report the player for assault and flee. This check is based on the player's willpower, the NPC's willpower, and the calculated amount of time. The following formula will be used for the success-check:
```lua
local function Calc(mobile)
   local luck = mobile.luck.current
   if (luck > 100) then luck = 100 end

   return mobile.willpower.current + random(luck,100) * .15
end

local playerCalc = Calc(tes3.mobilePlayer)
local npcCalc = Calc(npc.mobile)
return playerCalc >= npcCalc
```

While mesmerized, the NPC will be significantly more susceptible to feeding and will not recognize the player as a vampire.

### **Thralls**
A new service option will be added to all NPC dialogue windows: "Enthrall". Using this service option will open a new window. This window will have two options: "force enthrall" and "enthrall". If the player has fed on the NPC for a calculated number of times, they can enthrall the NPC with a 100% success rate. If the player has not met that requirement, they may force it upon the NPC. This will perform a success-check that is hard to pass. If either option is successful, the NPC's disposition will be raised to 100, they will allow you to feed on them at 100% success rate, and they will have the option to be a basic companion. If failed, the NPC will report the player for assault, the NPCs disposition will be lowered to 0, and the NPC will flee.

### **Sun Damage**
In addition to damaging health, sun damage will drain blood at a rate of 1pt per tick.


## License
You cannot copy, distribute, package, or otherwise modify in any way the contents of this repository. This repository represents in-progress, unpublished work by its authors and should only be used as a reference.

Any violations of this license will be reported on their respective platforms.
