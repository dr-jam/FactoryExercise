# ECS189L Programming Exercise 3: The Factory Pattern

## Description

The goals of this programming exercise are:
* to gain experience with the factory software design pattern
* to create significant portions of game programming systems from scratch or from lighter outlines
* to implement tables and equations (as given by designers) as game procedures and logic

### Grading

### Due Date and Submission Information

## Description of Provided Unity Project

### Scene and Game Objects in the Hierarchy

### Assets and Scripts

## Stage 1: Shields Online

The Aegis prototype shield mechanism is nearly complete. Your task to complete the shield's functionality by adding a recharging mechanism which consists of the following:
* Use the `RechargeRate` and `RechargeDelay` properties of the `SheildController` class to enable:
  * After the shield has taken damage or is not at maximum capacity, it enters a recharge delay peroid lasting `RechargeDelay` seconds.
  * After the recharge delay peroid, the shield begins to recharge at `RechargeRate` capacity points per second.
  * If the shield is damage before it is fully recharged, the shield stops recharging and enters another recharge delay peroid.
  * Shields cannot recharge greater than their `Capacity` value.
  * Shield capacity can never be negative.

## Stage 2: Damage Engine

Create a `DamageEngine` class that implements the following combat algorith:

damage = ProjectileDamage x (TypeFactor)

| Damage Type Factors |         | Shield Type |        |        |
|:-------------------:|:-------:|:-----------:|:------:|--------|
|                     |         |   Kenetic   | Energy | Arcane |
|  ProjectileType     | Kenetic |      1      |   0.5  |    2   |
|                     |  Energy |      2      |    1   |   0.5  |
|                     |  Arcane |     0.5     |    2   |    1   |

This class does not need to be a `MonoBehavior` or `ScriptableObject`. In fact, it doesn't necessarily have to be a class. It does need to provide a static function that takes the parameters of a shield and the parameters of a projectile and returns a damage value as deonted by the combat algorithm.

## Stage 3: Factories and Specifications

Your task is to create factories that generate shields and projectiles via specification classes. These generated items should be insantiated as `GameObjects`. Use shield and projectile placeholders in the Unity project as a guide for how they should interact with the scene. 

### Stage 3.1: Specific Construction

This task has the following objectivse:
1. Create a `ShieldFactory` and a `ProjectileFactory` using the factory design pattern.
2. You need to create `ShieldSpec` and `ProjectileSpec` classes whose only role is to hold a specification to be used by your factory. These type of data classes typically only have properties and no methods.
3. Your factories `Build` function should take a specification class as a parameter and should Instantiate a new `GameObject` based on the specification.
4. Your factories should be able `GenerateRandomShield`s and `GenerateRandomProjectile`s with properies within the stated specification ranges.

The automated factories in Aegis largely build to external specifications. Specifications consists of the following values and ranges:

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

Unfortunately, your factories are also limited in the quality of shields and projectiles they can produce. Sheilds are limited to a power rating of 300 while projetiles are limited to a rating of 100. Ratings can be determined by the following functions:

ShieldRating = Capacity + (5 - RechargeDelay) x 5 + RechargeRate * (RechargeRate / 2)

ProjectileRating = Damage x 2 + (3 - ChargeTime)^4

You factories should not produce shields or projectiles that have power ratings higher than the stated limits. If your factory receives a specification with a power rating over the stated limits, your factory should scale down the specification to be within the rating limit. How your factory scales down the specifications is your design choice; you could increase delay or chage times, lower all properties by a percentage, or even randomly generate an entirely new shield.

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

*[Still Alive](https://www.youtube.com/watch?v=Y6ljFaKRTrI), Portal, 2007, Jonathan Coulton*  


