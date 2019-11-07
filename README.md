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

## Stage 2: Damage Engine

damage = WeaponDamage x (TypeFactor)

| Damage Type Factors |         | Shield Type |        |        |
|:-------------------:|:-------:|:-----------:|:------:|--------|
|                     |         |   Kenetic   | Energy | Arcane |
|      WeaponType     | Kenetic |      1      |   0.5  |    2   |
|                     |  Energy |      2      |    1   |   0.5  |
|                     |  Arcane |     0.5     |    2   |    1   |
