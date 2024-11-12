# ECS189L Programming Exercise: The Factory Pattern

## Description

The goals of this programming exercise are:
* to gain experience with the factory software design pattern
* to create significant portions of game programming systems from scratch or lighter outlines
* to implement tables and equations (as given by designers) as game procedures and logic

### Grading
The points distribution for the stages totals 70 points and can be found in the table below. The remaining 30 points are for your peer review of another student's submission.

| Stage | Points |
|:-----:|:------:|
|  1    |   15   |
|  2    |   15   |
|  3.1  |   15   |
|  3.2  |   10   |
|  4    |   15   |


### Due Date and Submission Information

The due date and submission information are on the official class communication channels.

## Description of Provided Godot Project 

### Scene and Nodes

* **Main Camera** is the main viewport into the lab.
* **Laboratory** is the root scene that composes the testing facility's laboratory. Inside there are the sides of the room, test pedestals, a weapon, and a shield. 
  * **ShieldAparatus** contains a `ShieldGenerator` where the shields (i.e. the test subjects) spawn.
  * **WeaponAparatus** holds the test weapon that contains the `ProjectileSpawn` location for new `Projectile`s to spawn at.

### Assets and Scripts

Scenes of note:  
* **DamageIndicator** is a prefab that implements the dynamic health bar shown above the shield.
* **Projectile** is a prefab for the projectiles shot by the test weapon.

Scripts: 
* **Shield.cs** contains the game logic for test `Shield`s. It is where the refreshing capabilities of the shield should be implemented. It contains references to the `DamageIndicator` scene.
* **Effects** holds the `enum` for the projectile and shield types.
* **Laboratory** implements firing a `Projectile` instance that moves from the `ProjectileSpawn` toward the `ShieldAparatus` on `ui_accept` input. Your factory logic could go here.
* **Projectile** holds the physical parameters of the projectile and has information on the damage the projectile should do to a shield. It also controls the motion of the `Projectile`
* **DamageIndicator** partially controls the upward-scrolling damage values that appear when a `Projectile` collides with a `Shield`.

## Stage 1: Shields Online

The Aegis prototype shield mechanism is nearly complete. Your task is to complete the shield's functionality by adding a recharging mechanism which consists of the following:
* Use the `recharge_rate` and `rechare_delay` properties of the `Shield` class to enable:
  * After the shield has taken damage or is not at maximum capacity, it enters a recharge delay period lasting `recharge_delay` seconds.
  * After the recharge delay period, the shield begins to recharge at `recharge_rate` capacity points per second.
  * If the shield is damaged before it is fully recharged, the shield stops recharging and enters another recharge delay period.
  * Shields cannot recharge greater than their `max_capacity` value.
  * Shield `current_level` can never be negative.

## Stage 2: Damage Engine

Create a `DamageEngine` class that implements the following combat algorithm:

`damage = ProjectileDamage * (TypeFactor)`

| Damage Type Factors |         | Shield Type |        |        |
|:-------------------:|:-------:|:-----------:|:------:|--------|
|                     |         |   Kinetic   | Energy | Arcane |
|  **ProjectileType** | Kinetic |      1      |   0.5  |    2   |
|                     |  Energy |      2      |    1   |   0.5  |
|                     |  Arcane |     0.5     |    2   |    1   |

This class should be [autoloaded](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) via the Project Settings. This class does not need to be explicitly linked to a `Node`. It doesn't necessarily have to be a class. It does need to provide a static function that takes the parameters of a shield and the parameters of a projectile and returns a damage value as denoted by the combat algorithm. 

## Stage 3: Factories and Specifications

Your task is to create factories that generate shields and projectiles via specification classes. These generated items should be instantiated as `Node`s. Use shield and projectile placeholders in the project as a guide for how they should interact with the scene. 

### Stage 3.1: Specific Construction

This task has the following objectives:
1. Create a `ShieldFactory` and a `ProjectileFactory` using the factory design pattern.
2. You need to create `ShieldSpec` and `ProjectileSpec` classes whose only role is to hold a specification to be used by your factory. These types of data classes typically only have properties and no methods.
3. Your factory's `build` function should take a specification class as a parameter and should refresh the `Projectile`s and `Shield`s based on the specification.
4. Your factories should be able `generate_random_shield`s and `generate_random_projectile`s with properties within the stated specification ranges.

The automated factories in Aegis are primarily built to external specifications. Specifications consist of the following values and ranges:

Shield Specifications:
* Capacity: 50 to 250
* Recharge Delay: 0.5 to 5 seconds
* Recharge Rate: 1 to 25 capacity per second.
* Type: Kinetic, Energy, or Arcane.

Projectile Specifications:
* Damage: 1 to 50
* Charge Time: 0.5 to 3 seconds.
* Type: Kinetic, Energy, or Arcane.

### Stage 3.2: Power Underwhelming

Unfortunately, your factories are also limited in the quality of shields and projectiles they can produce. Shields are limited to a power rating of 300, while projectiles are limited to a rating of 100. The following functions can determine ratings:

`shield_rating = max_capacity + (5.0 - recharge_delay) * 5.0 + recharge_rate * (RechargeRate / 2.0)`

`projectile_rating = damage * 2.0 + (3.0 - charge_time) ** 4.0`

Your factories should not produce shields or projectiles with power ratings higher than the stated limits. If your factory receives a specification with a power rating over the stated limits, your factory should scale down the specification to be within the rating limit. How your factory scales down the specifications is your design choice; you could increase delay or change times, lower all properties by a percentage, or even randomly generate an entirely new shield.

## Stage 4: Still Alive

>This was a triumph!  
>I'm making a note here:  
>Huge success!  
>  
>It's hard to overstate  
>my satisfaction.  
>  
>Aperture Science:  
>We do what we must  
>because we can  
>For the good of all of us.  
>Except the ones who are dead.  

*[Still Alive](https://www.youtube.com/watch?v=VuLktUzq23c), Portal, 2007, Jonathan Coulton*  

In the grand traditions of automation and ever-increasing abstraction, this stage tasks you with creating a `TestFactory` that tests the output of factories.

Your `TestFactory`'s build method should create the following:
* A `ShieldSpec`.
  * A shield based on the generated specification.
* 5 to 10 `ProjectileSpecs`.
  * Projectile instantiations of those 5 to 10 `ProjectileSpec`s
* A `TestSchedule` that is capable of firing the projectiles in a sequential order while respecting their `ChargeTime`s.
* Setting up the generated `Shield` and the `TestSchedule` in the scene.
* Running the test by shooting the projectiles at the shield via the `TestSchedule`.

You should report failure and huge success with the appropriate fanfare.
