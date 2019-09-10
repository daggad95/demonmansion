# Demon Mansion Design Specification

from codeshare.io:
Scene spec:

## GUI / Menus

## Game
   * multiple waves
	* wave composition
  	* enemy dmg, enemy speed, spawn rate, enemy area density that is maintained
   * types of enemies, # of types of enemies
   * boss spawns ever x rounds gains new skill each time (until we run out)
    	* sprite changes as gets stronger
      * grotesque like halo flood
      * splits but loses proportional amount of health, sprite gets smaller
      * merges to combine health, sprite get thicc
	* UI stuff
  	   
## Player
   * Health
	* Player Controls  custom!
   * Inventory: pistol infinite ammo + 1 primary weapon
   * Money
   * primary/secondary show on model
   * 4 different models
   * unique colored gun and proj
   * functions
      * add_to_inventory(item)
      * get_inventory()
      * get_money()
	   * set_money()
  
## Weapons
   * Sprite animation
	* clip size
   * Projectile parameters
   * cost
   * color, proj color

## Enemy
   * randomly select spawn point from set 
  
## Projectiles
   * shoot weapon, create projectiles
   * kinematic body instance
   * has (animated) sprite, range, speed, damage, direction(?)
   * color
 
## Map
   * walls, non-walls
   * spawn points
   * store
  
## Store
   * accessed between rounds with a button press
   * clerk random dialogue
   * ui menu opens with purchase
   * store needs to know which player
  
## Camera 
   * average view of all players, tug of war lego star wars style
  
====================================
## Old design.md:

## Gameplay

* Top down 2d shooter
* Infinite waves of enemies
* Buy guns, shield, health.
* Enemies drop money, health.
* Various enemy types.
* 1 Boss, gets stronger every time he shows up.

## Enemy Types

* Zombie
    * Moves slowly
    * Melee damage
* Werewolf
    * Moves in pack
    * Fast
    * Coordinated attacks
* Fire spirit
    * Ranged attack
    * Catches you on fire if hit
* Ogre
    * Tanky
    * High damage
    * Very slow
    * Big range
* Kamaitachi (Sickle Weasle)
    * Lunge attack

* Demon (Boss)
    * Split into multiple
    * Go invisible
    * Melee AOE
    * Ranged spear projectile thing

## Weapon Types

* Pistol
    * Shitty trash
    * Starting weapon
* Shotgun
    * High spread, low pen
    * Fast damage dropoff
* Assault Rifle
    * Full auto
* Sniper
    * High pen
* Grenade Launcher

======================================
