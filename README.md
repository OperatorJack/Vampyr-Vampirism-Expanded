# Vampyr: Vampirism Expanded
Vampyr: Vampirism Expanded mod for TES III: Morrowind

## Description
Expands Vampirism in TES III: Morrowind by adding new mechanics, new spells, new items, and more for Vampires. At a cursory glance, these new mechanics are inspired by, but not limited to, the vampire mechanics found in the game *Vampyr*. Similar mechanics include blood statistics, serums, and some spells.

## Mechanics

### **Blood**   
The first and main new mechanic is the addition of a new player statistic to accompany *Health*, *Magicka*, and *Stamina* for vampires. This new statistic is called *Blood*. Visually, this new statistic will appear below *Stamina* in the HUD and player menu as a 4th, blood-red statistic bar. 

When transformed into a vampire, this new statistic will become available to the player. The base blood value will be calculated using the following formula, subject to change:
```lua
local base = (Insert exponential formula based on willpower and endurance)
```

The current blood value at the time of transformation will be **1**. This means that the player will start with **1 out of *base*** blood.

Unlike the other statistics, resting will not recover blood. Blood can only be restored via the actions outlined below. Blood degrades at an exponential rate as days pass without restoring blood. This means that for each day that passes, the player's blood level will decrease by an increasing amount. 

If the blood level reaches 0, the player will begin losing health at 1pt per second, increasing exponentially, until blood is increased above 0.

Blood can be restored via feeding and blood serums (restore blood effect potions).

Blood base amount can be permanently increased by levelling up, similarly to how Magicka is increased. The governing attributes are endurance and willpower. The following formula will be used:
```lua
local modAmount = (formula pending)
local newAmount = currentBaseBlood + modAmount
```

Blood can be consumed to use vampiric powers, spells and other special abilities, outlined below.

All NPCs will show the amount of blood you get per feeding as part of their UI tooltip. The amount of blood you get per feeding is calculated based on their level and attributes.

### **Blood Magic**   
Blood can be consumed to perform a new type of magic, blood magic. Blood magic functions similarly to regular magic, but costs blood instead of magicka. Blood magic centers around destruction and illusion type spells. 

Intended spell effects include: Feed, Mesmerize, Self-Feed, ...

### **Feeding**   
A new service option will be added to all NPC dialogue windows: "Feeding". Using this service option will perform a success-check. If successful, the player will feed on the NPC and gain a calculated blood amount. If failed, the NPC will report the player for assault and flee. A successful feeding increases disposition by a small amount.

### **Mesmerize**   
A new service option will be added to all NPC dialogue windows: "Mesmerize". Using this service option will perform a success-check. If successful, the NPC will be pacified and follow the player for a calculated amount of time. The calculated amount of time is based on the player's willpower and the NPC's willpower. At the end of the calculated amount of time, a success-check will be performed. If succesful, the NPC will have their disposition slightly increased. If failed, the NPC will report the player for assault and flee. This check is based on the player's willpower, the NPC's willpower, and the calculated amount of time.



## License
You cannot copy, distribute, package, or otherwise modify in any way the contents of this repository. This repository represents in-progress, unpublished work by its authors and should only be used as a reference.

Any violations of this license will be reported on their respective platforms.
