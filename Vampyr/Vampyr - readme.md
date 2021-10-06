# Vampyr: Vampirism Expanded

#### OperatorJack et. al.

---

## **Alpha 0.5.0**

## Requirements

- MGE version 13 (recently released!)
- Magicka Expanded

---

## Description

Expands Vampirism in TES III: Morrowind by adding new mechanics, new spells, new items, and more for Vampires. At a cursory glance, these new mechanics are inspired by, but not limited to, the vampire mechanics found in the game Vampyr. Similar mechanics include blood statistics, serums, and some spells.

---

## Credits

Credits are listed in alphabetical order.

_Alice L_ - Writing lore surrounding the mechanics and how they interact with the game world. Helping with the design of the mod mechanics. Author of _Introduction to Vampirism_.
_Greatness7_ - Animation toolkits allowing the creation of the claws mechanics. Tons of scripting help. My goto guy when in a pickle.
_Hrnchamd_ - Dehardcoding animation system in MWSE, allowing for new & advanced animation mechanics. Adding many new MWSE features to make my ideas a reality.
_JaceyS_ - All magic effect icons currently in Vampyr, as well as the alternative icons found in the repository.
_Kurp (Kurpulio)_ - All VFX seen in Vampyr. Without Kurp's help, this mod would be decidedly less cool.
_Melchior Darhk_ - Steel & Silver Stakes. Blood serum models. Blood Transfuser gauntlet.
_NullCascade_ - MWSE Lua and the tons of updates he has completed that made this mod possible. Continued help with MWSE.
_RedFurryDemon_ - Wooden Stake

---

## Alpha Version

This is an alpha version of Vampyr. It does not include all of the features outlined in the _Mechanics_ section. By playing this version, you are agreeing to test the mod. There is no promise that anything will work as expected. Please share feedback on the #vampyr channel of the Morrowind Modding Community discord. Thanks! - OJ

### Getting Started

Getting started is easy. Just become a vampire! Currently, the vanilla process to become a vampire is unchanged (perhaps in the future that won't be true). Once you become a vampire, the new mechanics will automatically kick-in.

- You can run the following console command to become a vampire and level up your blood levels: `startscript OJ_Vampyr_TestBecomeVampire`.
- You will become a vampire and have you blood level increased by 50 every 10 seconds for 100 seconds (10 times).
- There is not currently a way to increase blood level without using script commands. You can run the above command repeatedly.

Go to `coc vampyr_test` to see some test items and NPCs.

Use `SHIFT + /` to open the debug menu.

### Version History

The coming soon section describes what to expect in the next alpha version. Version roadmapping is not currently maintained.

#### **Coming Soon!**

- Blood Transfusion Mechanics
- Feeding Mechanics

The table below outlines functionality added or changed in each alpha version.

#### **0.5 - Basic Feeding, Vampire Merchants & Blood Serums**

- Feeding

  - Dialogue option "- Feed" is now visible when you are a vampire, and the actor you're speaking with is not a vampire.
  - Feed topic allows you to drink blood or extract blood into vials.
  - Drinking blood triggers the Feed mechanic, which will eventually show an animation and other features.
  - Extracting blood creates blood serums and damages the actor.
  - _Dialogue is placeholder and very much subject to change._

- Vampire Merchants

  - Any vampire that sells potions or ingrediants will now have a small respawning stock of blood serums.
  - Blood serum price fluctuates based on your relative rank in the faction of the merchant, your thirst, and your blood potency. A satiated daywalker will be able to buy blood serums much cheaper than a starving newborn.

- Blood Serums

  - New Icons

#### **0.4.1 - 0.4.3**

- Bugfixes

  - Fixed blood defaulting to -1/-1 during vampire transition. Now will correctly default to 1/30 (default formula changed in future update).
  - Fixed bug where blood potency data structure was incorrectly initiated, which could cause some logical errors when a newborn vampire.
  - Fixed bug where vampires could not deal damage with weapons due to incorrectly accessed property in claws logic.
  - Fixed bug where the last feed day was being initialized incorrectly, such that it would cause hunger damages even if you had just turned into a vampire.

#### **0.4 - The Ashfall & Glamour Update**

- Glamour

  - The glamour magic effect now overrides the PC Vampire dialogue check, allowing the player to converse as a normal being.
  - Glamour now has beautiful & unique cast and hit VFX created by Kurp!

- Ashfall

  - Add integrations with Ashfall. If it is installed, Vampyr will use the Ashfall sun temperature calculation instead of the Vampyr shade calculation when determining sun damage.
  - Add MCM menu to manage integrations.

- Mistform

  - Fixed a bug where the VFX pushed the player a small amount, causing a jarring camera motion.
  - Fixed a bug where the "Start" VFX was only played on the initial cast.
  - The "light" now stays after the effect ends, following the player for a few seconds.
  - On casting and ending of the effect, new stencil visuals to show transition into mist.

- Debug Menu

  - You can now add some items, like serum and blood transfuser, from the debug menu.
  - You can now spawn some NPCs, like the test NPC and test Vampire NPC, from the debug menu.

- Other
  - Merged the temporary blood transfuser ESP into main ESP.
  - Setup some functionality for Feeding. New MCM option and feeding key, defaulted to `x`.
  - Setup some functionality for Blood Transfusion. New improved meshes by Melchior Dahrk.

#### **0.3.1 - 0.3.3**

- Sun Damage

  - Improved VFX by Kurp.
  - Added Left Pauldron to stencil functionality, so VFX now shows correctly on it.
  - Fixed bug where changing equipment could break stencil VFX.
  - Fixed bug where high FPS could cause damage to not calculate correctly, causing VFX flickering.

#### **0.3 - The Sun Damage Update**

- Bugfixes

  - No longer attempts to set claw animations for beast bodies, preventing animation errors.

- Stencil Effects

  - Stencil properties are now used for all NPCs, creatures, and the player for more advanced VFX. Currently used in Sun Damage, but it may be used elsewhere too.

- Sun Damage

  - New VFX by Kurp
  - Using stencil properties to project burning VFX onto vampires.
  - Sun Damage now takes into account the amount of skin that is exposed on the vampire. Cover up! Absolute full coverage can negate sun damage.
  - Sun Damage now takes into account the amount of shade the vampire is in. Particularly, if will consider the amount of cloud coverage and glare present in the current weather. If the weather is transitioning, it will use values from the current and next weather. This is based on the vanilla sun damage formula.

- Transfusion
  - Added in Melchior's new Blood Transfuser assets. Not configured yet.

#### **0.2.1 - 0.2.3**

- Bugfixes

  - Misc fixes to improve blood mechanics and prevent errors.
  - Actually fixed being able to go beyond level 10 blood potency. (Whups)

- Game World

  - Added "Introduction to Vampirism" book to ESP. Not currently placed in game.

- Blood Spells

  - Vampiric Kiss spells changed from Transfuse Blood to Absorb Health.

- Bloodstorm

  - Recovers small amounts of blood for vampires nearby the Player during bloodstorm.
  - Demoralizes nearby NPCs and creatures during bloodstorm. Depending on their level, they may flee.
  - New VFX in future versions, maybe.

- Mistform

  - Player can no longer activate objects or cast spells while using mistform.
  - New, improved VFX by Kurp.
  - Fixing lighting issue in Mistform effect.
  - Removed default mysticism particle texture while casting.

- Debuging

  - Improved debug menu with more options for managing blood levels.
  - Added new TRACE log level for low level logging.
  - Added logging throughout Vampyr for better debugging.

#### **0.2.0 - June 3, 2021 - The Claws Update**

- Bugfixes

  - Fixed bug in Shadowstep where incorrect VFX was being used.
  - Fixed being able to go beyond level 10 blood potency.

- [**New!**] Debug Menu

  - You can now press `SHIFT + /` to open a debug menu. This has options to become a vampire, cure vampirism, and change blood levels.
  - Will be expanded in future updates.

- [**New!**] Claws

  - Vampires will attack with claws when using hand to hand, instead of fists.
  - Uses normal hand to hand controls.
  - Remaps beast fighting animation onto normal humanoids to use claw attacks. (Animation to be further improved)
  - Claw attacks can draw blood, restoring blood to the attacker. Drawn blood has a chance of increasing maximum blood for the attacking Vampire.
  - The Hand-to-hand skill and governing attributes, strength and speed, impacts how much blood can be drawn, and the frequency at which it is drawn.
  - MCM to manage base chance of triggering blood draw.

- Blood Serums (Object created, not implemented in-game)

  - New models by Melchior Darhk!
  - New big and mini serum models.

- Blood Spells

  - Redesigned Vampiric Touch Spells to use new effect (see below)
  - New Transfusion power, granted through the potency ladder.

- Blood Potency

  - Redesigned progression ladder to be better distributed based on new effects and spells.

- Blood Magic EFfects

  - New magic effect icons, created by JaceyS, for all magic effects.
  - [**Finished**] Mistform
    - Mistform now allows you to move through doors.
    - Mistform prevents you from being hit physically. Magic will still do damage to you.
    - Awesome new VFX made by Kurp!
  - [**New**] Transfuse Blood
    - Renamed from Drain Blood
    - Drains blood from vampires, or health from non-vampires.
  - [**New!**] Auspex
    - This effect is gained through the new _Vampiric Insight_ ability.
    - The functionality below is now part of the Auspex magic effect.
      - See NPC health in tooltip if player is vampire
      - See NPC blood in tooltip if both player and NPC are vampires
      - View NPC potency in tooltip if player and NPC are vampires
  - [**New!**] Fortify Claws
    - This effect is gained through new version of the Vampiric Touch spells.
    - Magnitude of this effect improves claw damage and blood draw by relative amount.

- Shadowstep
  - Shadowstep now supports custom keybindings, which can be found in the MCM.

#### **0.1.0 - May 19, 2021 - Initial Alpha Release**

- Blood Mechanic
  - Calculate Base Blood on becoming Vampire (or installing mod)
  - Blood Degradation
- User Interface
  - See blood in Stats menu
  - See blood in HUD
  - Blood in HUD changes color depending on level
  - See NPC health in tooltip if player is vampire
  - See NPC blood in tooltip if both player and NPC are vampires
  - Blood potency (see below)
- Blood Potency
  - Potency increase / decrease
  - Add / remove powers and abilities depending on potency
  - Show player potency in Stats menu
  - View NPC potency in tooltip if player and NPC are vampires
- Blood Serums (Object created, not implemented in-game)
- Blood Magic Spells
  - Show blood cost of Blood spells in Spell Menu tooltips.
  - Implemented placeholder spells for all powers and abilities. Some spells are completed.
- Blood Magic Effects
  - Restore Blood
  - Drain Blood
  - Resist Sun Damage
  - Bloodstorm (80%) - Pending powerups to other mechanics.
  - Mistform (80%) - Pending some MWSE updates and new VFX. Basically works.
  - Shadowstep
  - Glamour (20%)
- Stakes: Wooden, Steel, Silver (Object created, not implemented in-game)
- Fix NPC Vampirism: NPCs which are "Vampires" in vanilla but do not have the vampirism magic effect now have it. Managed via MCM.
- MCM: Initial MCM. Some configuration options.

---

## Mechanics

### **Blood**

The first and main new mechanic is the addition of a new player statistic to accompany _Health_, _Magicka_, and _Stamina_ for vampires. This new statistic is called _Blood_. Visually, this new statistic will appear in the HUD and player menu as a 4th, blood-red statistic bar.

When transformed into a vampire, this new statistic will become available to the player. The base blood value at the time of the transformation will be determined by the player's attributes.

The current blood value at the time of transformation will be **1**. This means that the player will start with **1 out of _base_** blood.

Unlike the other statistics, resting will not recover blood. Blood can only be restored via the actions outlined below. Blood degrades at an exponential rate as days pass without restoring blood. This means that for each day that passes, the player's blood level will decrease by an increasing amount. The blood degradation rate will be calculated using the following formula, subject to change:

```lua
local modAmount = -1 * (1.2 ^ daysPassed) - 20
```

If the blood level reaches 0, the player will begin losing health at 1pt per second until blood is increased above 0. Additionally, the player will begin losing base blood at 1pt per second until blood is increased above 0. Letting blood fall to 0 while not having fed will undo significant progression.

Blood can be restored via feeding and blood serums. Blood serums will also reset the feeding timer.

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

- Restore Blood: _Used by blood serumes._
- Drain Blood: _Drain blood from target and restore to caster._
- Shadowstep: _Teleport through shadows to targeted location._
- Mistform: _Turn to mist and move through actors and interior doors._
- Glamour: _The vampire will not be recognized as a vampire by anyone that is not also a vampire._

### **Shadowstep**

The player has the ability to teleport through shadows to any visible location. This will be mapped to a new key button, currently `z`. Press `z` again to commit the action. Press `alt` + `z` to cancel the action. Shadowstepping will have varying blood cost, depending on the distance being shadowstepped to.

### **Hand-to-hand for Vampires: Claw Attacks** [Subject to Change!]

If a vampire uses hand-to-hand, the normal animation will be replaced with one which has the vampire's hands in the form of a claw. While "punching" with claws, there is a small chance that the attacker will draw blood, granting them some blood restoration. This also has a chance to inflict vampirism on the target.

Clawing an actor can cause you to contract any diseases they have.

### **Feeding**: [Subject to Change!]

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

### **Mesmerize** [Subject to Change!]

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

While mesmerized, the NPC will be significantly more susceptible to feeding. Additionally, the _Glamour_ effect will be applied to the caster, applying some VFX and the target will not recognize the player as a vampire.

### **Thralls** [Subject to Change!]

A new service option will be added to all NPC dialogue windows: "Enthrall". Using this service option will open a new window. This window will have two options: "force enthrall" and "enthrall". If the player has fed on the NPC for a calculated number of times, they can enthrall the NPC with a 100% success rate. If the player has not met that requirement, they may force it upon the NPC. This will perform a success-check that is hard to pass. If either option is successful, the NPC's disposition will be raised to 100, they will allow you to feed on them at 100% success rate, and they will have the option to be a basic companion. If failed, the NPC will report the player for assault, the NPCs disposition will be lowered to 0, and the NPC will flee.

After a calculated period as a thrall, depending on thrall level and attributes, they can be converted to a vampire.

### **Sun Damage**

- In addition to damaging health, sun damage will drain blood at a rate of 1pt per tick.
- Sun Damage will cause a burning VFX while taking damage.

### **Blood Serums**

The player may drain blood from non-vampire thralls for later use by storing them in serums. These will function the same as potions and have the Restore Blood magic effect. Draining blood from a thrall using this method will have the same effects as feeding.

### **Stakes**

- per references in Blasphemous Revenants, stakes can be used to kill vampires. Stakes are not required, but will do increased damage to vampires only, when at lower health.
- small chance for NPCs to draw a stake when fighting a vampire at low health, including fighting the player.
- only thematically fitting NPCs will cary stakes (vampire hunters, ordinators).

### **Bloodstorm**

While active and in an exterior cell, rains blood. Consumes an immense amount of magicka. Blood magic is buffed and any vampire in the affected area regains 1 blood per second. Does not count as feeding. Non vampires are demoralized and highly likely to flee. Higher level vampiric mechanic (level 9).

### **Blood Summons** [Subject to Change!]

Use blood to summon a few select creatures to fight beside you. Does not cost magicka. More powerful summons require higher level of blood potency.

### **Bloodbound Items** [Subject to Change!]

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

- Claw attack drains health equal to 0.25 \* blood.
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

---

## License

You cannot copy, distribute, package, or otherwise modify in any way the contents of this repository. This repository represents in-progress, unpublished work by its authors and should only be used as a reference.

Any violations of this license will be reported on their respective platforms.
