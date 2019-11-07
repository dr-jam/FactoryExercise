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

Shield Specifications:
* Capacity: 50 to 250
* Recharge Delay: 0.5 to 5 seconds
* Recharge Rate: 1 to 25 capacity per second.
* Type: Kinetic, Energy, or Arcane.

Projectile Specifications:
* Damage: 1 to 50
* Charge Time: 0.5 to 3 seconds.
* Type: Kinetic, Energy, or Arcane.


ShieldRating = Capacity + (5 - RechargeDelay) x 5 + RechargeRate * (RechargeRate / 2)

ProjectileRating = Damage x 2 + (3 - ChargeTime)^4

### Stage 3.1: Basic Projectile and Shield Factories

Create two basic factories. The first should generate shields
