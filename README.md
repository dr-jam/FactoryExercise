# ECS189L Programming Exercise: The Factory Pattern

## Learning goals

In this exercise, you will:

* apply the factory design pattern to a small game system;
* implement game behavior from specifications, tables, and equations; and
* test and evaluate the behavior of the system you build.

The supplied project is a Godot 4 project written in GDScript. The requirements below use the names and conventions in that project.

## Grading and submission

The implementation stages are worth 70 points. The remaining 30 points are for your peer review of another student's submission.

| Stage | Points |
|:-----:|:------:|
| 1 | 15 |
| 2 | 15 |
| 3.1 | 15 |
| 3.2 | 10 |
| 4 | 15 |

Due dates and submission instructions are provided through the official class communication channels. Optional Developed competency pathways are described at the end of this document; follow your instructor's directions about which pathways to submit for competency assessment.

## Provided Godot project

Open the `aegis` directory as a Godot project. The project uses GDScript, not C#.

### Scene and scripts

The `Laboratory` scene contains the test environment, the shield apparatus, and the weapon apparatus. The shield spawns at the shield apparatus; the weapon fires projectiles from its projectile spawn point.

Scripts relevant to this exercise include:

* `aegis/scripts/shield.gd` (`Shield`): shield capacity, damage handling, visual feedback, and the recharge behavior for Stage 1.
* `aegis/scripts/projectile.gd` (`Projectile`): projectile properties, charge timer, movement, and collision.
* `aegis/scripts/effects.gd` (`Effects`): the `Effects.Type` enum and effect colors. The kinetic enum member is spelled `KENETIC` in the supplied project.
* `aegis/scripts/laboratory.gd` (`Laboratory`): the laboratory's firing behavior.
* `aegis/scripts/damage_indiciator.gd` (`DamageIndicator`): the damage display shown when a projectile hits a shield.

The project autoloads `effects` and `signals`. Stage 2 adds the damage calculation service as another autoload.

## Core implementation stages

### Stage 1: Shields Online
The Aegis prototype shield mechanism is nearly complete. Your task is to complete the shield's functionality by adding a recharging mechanism which consists of the following:
Complete the recharge behavior in `Shield`, using its `recharge_rate`, `recharge_delay`, `max_capacity`, and `current_level` properties.

Requirements:

* A shield starts at its maximum capacity.
* After a hit, wait `recharge_delay` seconds before recharging. A later hit restarts that delay.
* Recharge at `recharge_rate` capacity points per second after the delay.
* Stop recharging at `max_capacity`; never allow `current_level` below zero or above the maximum.
* If a shield is created below its maximum capacity, it observes one recharge delay before it begins recharging.

Demonstrate the behavior with tests or a repeatable in-game demonstration covering a hit, the delay, recharge, a second hit during recharge, and both capacity bounds.

### Stage 2: Damage Engine

Create a damage calculation service with a static function that accepts the relevant shield and projectile properties and returns:

`damage = projectile_damage * type_factor`

| Projectile type | Kinetic shield | Energy shield | Arcane shield |
|:---------------:|:--------------:|:-------------:|:-------------:|
| Kinetic | 1 | 0.5 | 2 |
| Energy | 2 | 1 | 0.5 |
| Arcane | 0.5 | 2 | 1 |

This class should be [autoloaded](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) via the Project Settings. This class does not need to be explicitly linked to a `Node`. It doesn't necessarily have to be a class. It does need to provide a static function that takes the parameters of a shield and the parameters of a projectile and returns a damage value as denoted by the combat algorithm. 
### Stage 3: Factories and Specifications

Your task is to create factories that generate shields and projectiles via specification classes. These generated items should be instantiated as `Node`s. Use shield and projectile placeholders in the project as a guide for how they should interact with the scene. 

#### Stage 3.1: Specific Construction

Create `ShieldSpec`, `ProjectileSpec`, `ShieldFactory`, and `ProjectileFactory`.

Each factory must:

* provide a `build` function that accepts the matching specification and returns a newly instantiated, configured node
* copy all specified properties to the new node, including its type
* provide a random-generation function that returns a specification whose values are within the ranges below.

The factory creates the node but does not add it to the scene tree. The caller is responsible for parenting and freeing it. 

The automated factories in Aegis are primarily built to external specifications. Specifications consist of the following values and ranges:

| Shield property | Allowed range |
|---|---:|
| Capacity (`max_capacity`) | 50–250 |
| Recharge delay (`recharge_delay`) | 0.5–5 seconds |
| Recharge rate (`recharge_rate`) | 1–25 capacity points per second |
| Type | Kinetic, Energy, or Arcane |

| Projectile property | Allowed range |
|---|---:|
| Damage | 1–50 |
| Charge time (`charge_time`) | 0.5–3 seconds |
| Type | Kinetic, Energy, or Arcane |

#### Stage 3.2: Power Underwhelming

Unfortunately, your factories are also limited in the quality of shields and projectiles they can produce. Additionally, the adjusted values must remain within the Stage 3.1 ranges. The following functions can determine ratings:

Use these rating equations:

`shield_rating = max_capacity + (5.0 - recharge_delay) * 5.0 + recharge_rate * (recharge_rate / 2.0)`

`projectile_rating = damage * 2.0 + (3.0 - charge_time) ** 4.0`

The maximum ratings are 300 for a shield and 100 for a projectile. A rating equal to the limit is allowed. Your adjustment policy is your design choice. Document it and test an in-range specification, an over-budget specification, and a specification that lands exactly at the limit.

### Stage 4: Still Alive
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

In the grand traditions of automation and ever-increasing abstraction, this stage tasks you with creating a `TestFactory` that tests the output of factories. Build a `TestFactory` that creates and runs a repeatable test using the factories from Stage 3. The test must:

* create one `ShieldSpec` and build its shield
* create between 5 and 10 `ProjectileSpec` values and build their projectiles
* create a `TestSchedule` that launches the projectiles in order, waiting for each projectile's `charge_time` before launching it
* add the shield and schedule to the scene and run the test
* report whether the test passed, and identify any failed checks

Use a known random seed so a run can be reproduced. Record the seed, generated specifications, expected results, and observed results. A test passes only when the observed behavior matches the expected results and all applicable invariants hold: damage follows the Stage 2 table, shield levels stay within their bounds, recharge follows Stage 1, and factory products meet their specification ranges and rating limits. Include at least one failure run and one passing run in your evidence. Do not report success merely because the scene ran without an error.

## Optional Developed competency pathways

These pathways extend the core exercise. They are intended to demonstrate independent application of the system, not just completion of another prescribed feature. Your instructor will tell you which pathway or pathways to complete and how to submit the evidence.

### Debugging and Testing — extend Stage 4

Use the test runner to diagnose a nontrivial defect in the combat or factory system, correct its underlying cause, and add a regression test that would fail before the fix and pass afterward. Add tests for at least two boundary or interaction cases, such as:

* a second hit interrupting shield recharge;
* a hit exceeding the shield's remaining capacity;
* a factory specification exactly at or slightly above a rating limit; or
* a sequence of projectiles with different charge times.

**Evidence:** executable tests, an expected-versus-observed failure trace, a concise explanation of the defect and its cause, and a passing regression test.

### Interaction Design — Stage 4.1: Laboratory Operator Console

Design and implement a small laboratory console that lets an operator select or generate a projectile, fire it, start a test run, and understand the shield and test status. Address at least two interaction problems, for example:

* communicating whether a projectile is charging or ready;
* distinguishing shield recharge delay from active regeneration;
* explaining why a projectile caused a particular amount of damage; or
* preventing or explaining attempts to fire while a scheduled test is running.

The console must respond to actual events from the game systems. Decorative labels or animation without useful control or feedback do not meet this requirement.

**Evidence:** a functioning console, a concise explanation of the interaction decisions, and a demonstration of the two scenarios addressed.

### Evaluation and Iteration — extend Stage 3.2

Implement an evaluation runner that applies two factory adjustment policies to the same reproducible batch of specifications, including over-budget inputs. Choose a measurable criterion for evaluating a policy—for example, preserving relative specification strengths, avoiding preference for a projectile type, or maintaining a desired damage distribution. Compare the results, revise one policy based on the evidence, and evaluate it again. Where useful, test the resulting projectiles against shields of each type.

**Evidence:** the evaluation criterion, reproducible before-and-after results, a documented policy revision, and an explanation of whether the revision improved the chosen criterion.

## Assessment evidence

For each submitted stage or pathway, make the result easy to reproduce and inspect. Include the tests or short demonstration needed to verify the requirements, plus a brief explanation of design choices where the requirements leave a choice. For Developed pathways, the evidence should show the student's reasoning and measured or observed results; the assessor should not have to infer intent from the code alone.
