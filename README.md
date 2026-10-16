# ECS 179 Programming Exercise 3: The Factory Pattern

*Welcome to the Aegis Testing Initiative. We congratulate you on your selection for a position involving shield technology, projectile technology, and a scientifically acceptable amount of property damage.*

## Competency Claims and Descriptions

You comptency claims and other information we need to know to best grade your work.

## Learning goals

In this exercise, you will:

* apply the factory design pattern to a small game system
* implement game behavior from specifications, tables, and equations
* test and evaluate the behavior of the system you build

The supplied project is a Godot 4 project written in GDScript. The requirements below use the names and conventions in that project. Changes to the test chamber are expected. Changes to the laws of arithmetic are not.

## Competency assessment and submission

This exercise is assessed through your individual competency profile. Completing a stage provides evidence for the competencies listed below. The level shown is the level that the stage is designed to demonstrate when its requirements are met and the evidence supports the claim; a working scene alone does not automatically establish that level.

| Stage | Competency evidence | Target level |
|:---|:---|:---|
| **1. Shields Online** | Game Systems; Engine Usage | Unlocked; Unlocked |
| **2. Damage Engine** | Game Systems | Unlocked |
| **3.1. Specific Construction** | Design Patterns; Engine Usage | Unlocked; Unlocked |
| **3.2. Power Underwhelming** | Game Systems | Developed |
| **4. Still Alive** | Debugging and Testing; System Interrelations | Unlocked; Developed |
| **Optional: Debugging and Testing** | Debugging and Testing | Developed |
| **Optional: 4.1. Laboratory Operator Console** | Interaction Design | Developed |
| **Optional: Evaluation and Iteration** | Evaluation and Iteration | Developed |

The course uses four competency levels:

* **Locked:** The submitted work does not yet provide sufficient evidence of the competency.
* **Unlocked:** You can apply a taught technique in a guided context and show that it works.
* **Developed:** You can apply the technique with meaningful independent decisions or adaptations, verify a nontrivial case, and explain your choices.
* **Mastered:** You can identify and solve a substantial problem independently, consider alternatives and tradeoffs, and verify normal and failure cases. More features or more code are not, by themselves, evidence of Mastered work.

The **core stages** are the expected implementation of Exercise 3. The optional pathways at the end of this README are opportunities to provide additional Developed evidence; choose the pathways that are useful for your competency profile. You may submit **up to two additional competency claims** for Developed or Mastered assessment. A claim must point to identifiable evidence in your submitted project. Additional claims are not automatically accepted simply because a feature is present.

For each additional claim, provide:

* **Competency:** Which competency are you claiming?
* **Level:** Developed or Mastered.
* **Evidence:** Paths to relevant scripts/scenes/tests and instructions for reproducing a result.
* **Explanation:** What you did, what independent decision or problem it demonstrates, and how the evidence supports the level.
* **Assistance:** Identify substantial assistance, including help from people or generative AI, and explain your own contribution.

A claim may be verified at the requested level, verified at a lower level, returned for revision, or found unsupported. Mastered claims may require an individual demonstration or explanation. Follow the course competency guide and your instructor's directions for submission requirements and due dates.

*Corporate reminds you that a badge marked “Mastered” is not a substitute for verifiable experimental results.*

## Provided Godot project

Open the `aegis` directory as a Godot project. The project uses GDScript and is in Compatibilty mode.

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

*The Aegis shield is excellent at absorbing damage. Its present difficulty is remembering that it is supposed to recover afterward. This is a minor issue, according to the department responsible for ordering new shields.*

The Aegis prototype shield mechanism is nearly complete. Your task is to complete the shield's functionality by adding a recharging mechanism.

Complete the recharge behavior in `Shield`, using its `recharge_rate`, `recharge_delay`, `max_capacity`, and `current_level` properties.

Requirements:

* A shield starts at its maximum capacity.
* After a hit, wait `recharge_delay` seconds before recharging. A later hit restarts that delay.
* Recharge at `recharge_rate` capacity points per second after the delay.
* Stop recharging at `max_capacity`; never allow `current_level` below zero or above the maximum.
* If a shield is created below its maximum capacity, it observes one recharge delay before it begins recharging.

Demonstrate the behavior with tests or a repeatable in-game demonstration covering a hit, the delay, recharge, a second hit during recharge, and both capacity bounds.

**Competency evidence:** Game Systems — Unlocked; Engine Usage — Unlocked. Your implementation should demonstrate how timed state changes are managed in Godot and how the result can be inspected.

### Stage 2: Damage Engine

*The scientists have determined that some projectiles are more effective against some shields than others. After considerable deliberation, they have agreed to stop arguing and use a table.*

Create a damage calculation service with a static function that accepts the relevant shield and projectile properties and returns:

`damage = projectile_damage * type_factor`

| Projectile type | Kinetic shield | Energy shield | Arcane shield |
|:---------------:|:--------------:|:-------------:|:-------------:|
| Kinetic | 1 | 0.5 | 2 |
| Energy | 2 | 1 | 0.5 |
| Arcane | 0.5 | 2 | 1 |

This class should be [autoloaded](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) via the Project Settings. This class does not need to be explicitly linked to a `Node`. It doesn't necessarily have to be a class. It does need to provide a static function that takes the parameters of a shield and the parameters of a projectile and returns a damage value as denoted by the combat algorithm.

**Competency evidence:** Game Systems — Unlocked. Show that the implementation agrees with the damage table, including interactions between unlike types.

### Stage 3: Factories and Specifications

*We have concluded that hand-building experimental equipment is slow, expensive, and an unacceptable use of test subjects. Fortunately, factories can make the equipment automatically. They cannot yet file the paperwork.*

Your task is to create factories that generate shields and projectiles via specification classes. These generated items should be instantiated as `Node`s. Use shield and projectile placeholders in the project as a guide for how they should interact with the scene.

#### Stage 3.1: Specific Construction

*Please do not confuse a specification with a finished shield. One is a description of protective equipment. The other may briefly provide protection.*

Create `ShieldSpec`, `ProjectileSpec`, `ShieldFactory`, and `ProjectileFactory`.

Each factory must:

* provide a `build` function that accepts the matching specification and returns a newly instantiated, configured node;
* copy all specified properties to the new node, including its type; and
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

**Competency evidence:** Design Patterns — Unlocked; Engine Usage — Unlocked. Demonstrate that factories construct correctly configured nodes from specifications without silently adding them to the scene tree.

#### Stage 3.2: Power Underwhelming

*Your factories have been assigned power budgets. Requests for additional power have been denied. The facility needs the electricity for a different experiment, which is going extremely well and should not be investigated.*

Unfortunately, your factories are also limited in the quality of shields and projectiles they can produce. Additionally, the adjusted values must remain within the Stage 3.1 ranges. The following functions determine ratings:

`shield_rating = max_capacity + (5.0 - recharge_delay) * 5.0 + recharge_rate * (recharge_rate / 2.0)`

`projectile_rating = damage * 2.0 + (3.0 - charge_time) ** 4.0`

The maximum ratings are 300 for a shield and 100 for a projectile. A rating equal to the limit is allowed. Your adjustment policy is your design choice. Document it and test an in-range specification, an over-budget specification, and a specification that lands exactly at the limit.

**Competency evidence:** Game Systems — Developed. The rating formulas are prescribed, but how you adjust an over-budget specification is not. Explain your policy, demonstrate its behavior, and verify the constraints. The optional Evaluation and Iteration pathway goes further by comparing and revising policies using measured results.


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

*The facility has issued a new testing directive: an experiment that runs is not necessarily an experiment that passes. The distinction is important to our insurance department.*

In the grand traditions of automation and ever-increasing abstraction, this stage tasks you with creating a `TestFactory` that tests the output of factories. Build a `TestFactory` that creates and runs a repeatable test using the factories from Stage 3. The test must:

* create one `ShieldSpec` and build its shield
* create between 5 and 10 `ProjectileSpec` values and build their projectiles
* create a `TestSchedule` that launches the projectiles in order, waiting for each projectile's `charge_time` before launching it
* add the shield and schedule to the scene and run the test
* report whether the test passed, and identify any failed checks

Use a known random seed so a run can be reproduced. Record the seed, generated specifications, expected results, and observed results. A test passes only when the observed behavior matches the expected results and all applicable invariants hold: damage follows the Stage 2 table, shield levels stay within their bounds, recharge follows Stage 1, and factory products meet their specification ranges and rating limits. Include at least one failure run and one passing run in your evidence. Do not report success merely because the scene ran without an error.

**Competency evidence:** Debugging and Testing — Unlocked; System Interrelations — Developed. Demonstrate a reproducible test process that brings specifications, factory construction, projectile timing, damage, and shield behavior together.

## Optional Developed competency pathways

These pathways extend the core exercise. They are intended to demonstrate independent application of the system, not just completion of another prescribed feature. Choose the work that supports your competency profile, observing the limit of two additional claims described above.

*These experiments are optional. Their results, should you elect to pursue them, will be recorded for science. The facility accepts no responsibility for the emotional consequences of unexpected data.*

### Debugging and Testing — extend Stage 4

*Our records indicate that every system is functioning perfectly. Your assignment is to investigate a carefully documented exception to this statement.*

Use the test runner to diagnose a nontrivial defect in the combat or factory system, correct its underlying cause, and add a regression test that would fail before the fix and pass afterward. Add tests for at least two boundary or interaction cases, such as:

* a second hit interrupting shield recharge;
* a hit exceeding the shield's remaining capacity;
* a factory specification exactly at or slightly above a rating limit; or
* a sequence of projectiles with different charge times.

**Evidence:** executable tests, an expected-versus-observed failure trace, a concise explanation of the defect and its cause, and a passing regression test.

### Interaction Design — Stage 4.1: Laboratory Operator Console

*Previous operators complained that the console failed to distinguish “charging” from “about to fire.” Their feedback has been archived. You are invited to make the next console more informative.*

Design and implement a small laboratory console that lets an operator select or generate a projectile, fire it, start a test run, and understand the shield and test status. Address at least two interaction problems, for example:

* communicating whether a projectile is charging or ready;
* distinguishing shield recharge delay from active regeneration;
* explaining why a projectile caused a particular amount of damage; or
* preventing or explaining attempts to fire while a scheduled test is running.

The console must respond to actual events from the game systems. Decorative labels or animation without useful control or feedback do not meet this requirement.

**Evidence:** a functioning console, a concise explanation of the interaction decisions, and a demonstration of the two scenarios addressed.

### Evaluation and Iteration — extend Stage 3.2

*The factory has passed its power inspection. Whether it produces useful equipment is a separate question, currently under review by the Department of Science.*

Implement an evaluation runner that applies two factory adjustment policies to the same reproducible batch of specifications, including over-budget inputs. Choose a measurable criterion for evaluating a policy—for example, preserving relative specification strengths, avoiding preference for a projectile type, or maintaining a desired damage distribution. Compare the results, revise one policy based on the evidence, and evaluate it again. Where useful, test the resulting projectiles against shields of each type.

**Evidence:** the evaluation criterion, reproducible before-and-after results, a documented policy revision, and an explanation of whether the revision improved the chosen criterion.

## Assessment evidence

*The experiment is not complete until someone else can reproduce it. Preferably someone who is not currently standing in the projectile lane.*

For each submitted stage or pathway, make the result easy to reproduce and inspect. Include the tests or short demonstration needed to verify the requirements, plus a brief explanation of design choices where the requirements leave a choice. For Developed pathways, the evidence should show the student's reasoning and measured or observed results; the assessor should not have to infer intent from the code alone.