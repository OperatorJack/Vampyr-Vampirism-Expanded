# Vampyr: Vampirism Expanded
Vampyr: Vampirism Expanded mod for TES III: Morrowind

## Description
Expands Vampirism in TES III: Morrowind by adding new mechanics, new spells, new items, and more for Vampires. At a cursory glance, these new mechanics are inspired by, but not limited to, the vampire mechanics found in the game *Vampyr*. Similar mechanics include blood statistics, serums, and some spells.

## Mechanics

### **Blood**   
The first and main new mechanic is the addition of a new player statistic to accompany *Health*, *Magicka*, and *Stamina* for vampires. This new statistic is called *Blood*. Visually, this new statistic will appear in the HUD and player menu as a 4th, blood-red statistic bar. 

When transformed into a vampire, this new statistic will become available to the player. The base blood value at the time of the transformation will be determined by the player's attributes.

The current blood value at the time of transformation will be **1**. This means that the player will start with **1 out of *base*** blood.

Unlike the other statistics, resting will not recover blood. Blood can only be restored via the actions outlined below. Blood degrades at an exponential rate as days pass without restoring blood. This means that for each day that passes, the player's blood level will decrease by an increasing amount. The blood degradation rate will be calculated using the following formula, subject to change:
```lua
local modAmount = -1 * (1.2 ^ daysPassed) - 20
```

If the blood level reaches 0, the player will begin losing health at 1pt per second until blood is increased above 0. Additionally, the player will begin losing base blood at 1pt per second until blood is increased above 0. Letting blood fall to 0 while not having fed will undo significant progression.

Blood can be restored via feeding and blood serums (restore blood effect potions). Blood serums will also reset the feeding timer.

Blood base amount can be permanently increased by feeding, succesfully using certain vampiric powers, and other ways.

Blood can be consumed to use vampiric powers, spells and other special abilities, outlined below.

All NPCs will show the amount of blood you get per feeding as part of their UI tooltip. The amount of blood you get per feeding is calculated based on their level and attributes, using this formula:
```lua
local bloodAmount = 10 + level * 4 - (endurance/10) - (willpower/10)
```

All Vampires will show the amount of blood they have as part of their UI tooltip.

### **Blood Magic**   
Blood can be consumed to perform a new type of magic, blood magic. Blood magic functions similarly to regular magic, but costs blood instead of magicka. Blood magic centers around destruction and illusion type spells. 

Intended spell effects include: 
- Restore Blood: *Used by blood serumes.*
- Drain Blood: *Drain blood from target and restore to caster.*
- Mirage: *Hide Vampire Status while active.*
- Shadowstep: *Teleprot through shadows to targeted location.*
- Mistform: *Turn to mist and move through actors.*
- Glamour: *The vampire will not be recognized as a vampire by anyone that is not also a vampire.*

### **Shadowstep**
The player will have the ability to travel through shadows to any visible location. This will be mappd to a new key button. Shadowstepping will have varying blood cost, depending on the distance being shadowstepped to.

### **Hand-to-hand for Vampires: Claw Attacks**
If a vampire uses hand-to-hand, the normal animation will be replaced with one which has the vampire's hands in the form of a claw. While "punching" with claws, there is a small chance that the attacker will draw blood, granting them some blood restoration. This also has a chance to inflict vampirism on the target.

Clawing an actor can cause you to contract any diseases they have.

### **Feeding**   
A new service option will be added to all NPC dialogue windows: "Feed Upon". Using this service option will perform a success-check. If successful, the player will feed on the NPC and gain a calculated blood amount. If failed, the NPC will report the player for assault and flee. A successful feeding increases disposition by a small amount. The feeding success state and timestamp will be saved to for the NPC for later usage. The following formula will be used for the success-check:
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
As part of becoming more powerful, vampires will received a new blood magic power called Mesmerize. Using this power will perform a success-check. If successful, the NPC will be pacified and follow the player for a calculated amount of time. The calculated amount of time is based on the player's willpower and the NPC's willpower. At the end of the calculated amount of time, a success-check will be performed. If succesful, the NPC will have their disposition slightly increased. If failed, the NPC will report the player for assault and flee. This check is based on the player's willpower, the NPC's willpower, and the calculated amount of time. The following formula will be used for the success-check:
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

While mesmerized, the NPC will be significantly more susceptible to feeding. Additionally, the *Glamour* effect will be applied to the caster, applying some VFX and the target will not recognize the player as a vampire.

### **Thralls**
A new service option will be added to all NPC dialogue windows: "Enthrall". Using this service option will open a new window. This window will have two options: "force enthrall" and "enthrall". If the player has fed on the NPC for a calculated number of times, they can enthrall the NPC with a 100% success rate. If the player has not met that requirement, they may force it upon the NPC. This will perform a success-check that is hard to pass. If either option is successful, the NPC's disposition will be raised to 100, they will allow you to feed on them at 100% success rate, and they will have the option to be a basic companion. If failed, the NPC will report the player for assault, the NPCs disposition will be lowered to 0, and the NPC will flee.

After a calculated period as a thrall, depending on thrall level and attributes, they can be converted to a vampire.

### **Sun Damage**
* In addition to damaging health, sun damage will drain blood at a rate of 1pt per tick.
* Sun Damage will cause a burning VFX while taking damage.

### **Blood Serums**
The player may drain blood from non-vampire thralls for later use by storing them in serums. These will function the same as potions and have the Restore Blood magic effect. Draining blood from a thrall using this method will have the same effects as feeding.

### **Stakes**
- per references in Blasphemous Revenants, stakes can be used to kill vampires. Stakes are not required, but will do increased damage to vampires only, when at lower health.
- small chance for NPCs to draw a stake when fighting a vampire at low health, including fighting the player.
- only thematically fitting NPCs will cary stakes (vampire hunters, ordinators).

### **Bloodstorm** 
While active and in an exterior cell, rains blood. Consumes an immense amount of magicka. Blood magic is buffed and any vampire in the affected area regains 1 blood per second. Does not count as feeding. Non vampires are demoralized and highly likely to flee. Higher level vampiric mechanic (level 9).

### **Blood Summons** 
Use blood to summon a few select creatures to fight beside you. Does not cost magicka. More powerful summons require higher level of blood potency.

### **Bloodbound Items**
Use blood to summon a few select bound items. Does not cost magicka. More powerful summons require higher level of blood potency.

### Vampiric Power Level
Each vampire has a power level, determined by their blood level. This power level determines what mechanics, spells, and abilities, they have access to. 

```lua
local level = 1 + math.floor(baseBlood / 50)
```

Additionally, some mechanics, spells, and abilities may be more powerful or succesful at later levels. 

Levels 1 - 10 will be supported.

#### Level 1 (0 - 49): Newborn
Available mechanics:
- Claw
- Feed Upon / Force Feed

Standard magic Spells and abilities:
- Weak Vampiric Touch (Paralyze 2 seconds on touch)
- Weak Vampiric Kiss (Drain blood 5pts on touch)

Blood magic Spells and abilities:
- Blood Summon: Bat (if T_D installed) or Scamp

#### Level 2 (50 - 99): Fledgling
Available mechanics, including previous levels:
- Feed Upon / Force Feed chances increased.

Standard magic Spells and abilities:
- Lesser Vampiric Touch (Paralyze 5 seconds on touch)
- Lesser Vampiric Kiss (Drain blood 15pts on touch)

Blood magic Spells and abilities:
- Mirage (30 seconds on self)

#### Level 3 (100 - 149): Minion
Available mechanics, including previous levels:
- Feed Upon / Force Feed chances increased.
- Mesmerize
- Enthrall

Blood magic Spells and abilities:
- ~~Bloodbound Dagger~~ TO BE REPLACED

#### Level 4 (150 - 199): Servant
Available mechanics, including previous levels:
- Mesmerize chances increased.
- Shadowstep

Standard magic Spells and abilities:
- Vampiric Touch (Paralyze 10 seconds on touch)
- Vampiric Kiss (Drain blood 25pts on touch)

Blood magic Spells and abilities:
- Mistform (Mistform 10 seconds on self)

#### Level 5 (200 - 249): Adept
Available mechanics, including previous levels:
- Shadowstep cost decreased.
- Enthrall chances increased.

Blood magic Spells and abilities:
- Enslave (Force Enthrall on touch)
- Blood Summon: Daedroth

#### Level 6 (250 - 299): Subjugator
Available mechanics, including previous levels:
- Shadowstep cost decreased.
- Enthrall chances increased.
- Force enthrall 100% success rate.

Blood magic Spells and abilities:
- ~~Bloodbound Shortsword~~ TO BE REPLACED

#### Level 7 (300 - 349) Lord / Lady
Available mechanics, including previous levels:
- Claw attack drains health equal to 0.25 * blood.
- Resistance to Sun Damage 20%

Blood magic Spells and abilities:

#### Level 8 (350 - 399) Master / Mistress
Available mechanics, including previous levels:
- Resistance to Sun Damage 35%

Blood magic Spells and abilities:
- Blood Summon: Dremora

#### Level 9 (400 - 449) Elder
Available mechanics, including previous levels:
- Resistance to Sun Damage 50%

Blood magic Spells and abilities:
- ~~Bloodbound Longsword~~ TO BE REPLACED

#### Level 10 (450+) Daywalker
Available mechanics, including previous levels:
- Claw attack paralyzes for 1 seconds. 
- Immunity to Sun Damage

Standard magic Spells and abilities:
- Greater Vampiric Touch (Paralyze 30 seconds on touch)
- Greater Vampiric Kiss (Drain blood 100pts on touch)

Blood magic Spells and abilities:
- Bloodstorm

## License
You cannot copy, distribute, package, or otherwise modify in any way the contents of this repository. This repository represents in-progress, unpublished work by its authors and should only be used as a reference.

Any violations of this license will be reported on their respective platforms.
