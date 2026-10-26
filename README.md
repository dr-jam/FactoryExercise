# ECS 179 Programming Exercise 3: The Factory Pattern

*Welcome to the Aegis Testing Initiative. We congratulate you on your selection for a position involving shield technology, projectile technology, and a scientifically acceptable amount of property damage.*


<!-- ## Competency Claims and Descriptions

Your comptency claims and other information we need to know to best grade your work. For each claim, use this template

### Comptency: Level

#### Implementation
*What you changed, with links or paths to the relevant scripts and scenes.*
#### Reasoning
*Why you made those decisions; cite the reading or course concept when required.*
#### Demonstration
*Steps we can follow to reproduce the feature and the contrasting or edge cases requested above.*
#### Results
*What happened, including the outside-user observation if you're claiming Interaction Design.*
#### Assistance
*Substantial help you received, including use of generative AI, and which parts you completed yourself.*

*Run the game from a clean checkout before submitting. Make sure the steps in your evidence file actually work. If your design intentionally changes the default laboratory test, say how to run your version.*

### Game Design Reasoning: Developed

### Design Context: Developed

### System Interrelations: Developed

### Interaction Design: Developed -->


## Description

Aegis is a Godot 4 project that manufactures shields and projectiles using the Factory Pattern and runs automated combat tests. The starter project already handles damage types, shield recharge, equipment specifications, and test sequences.

Your assignment is to extend it. You can change the rules, change how someone interacts with the laboratory, or turn the test into a different kind of game. The change needs to work, and you need to explain the decisions behind it.

There are four competencies available: Game Design Reasoning, Design Context, System Interrelations, and Interaction Design. Demonstrate any two at Developed to receive the exercise completion bonus. You may use one extension as evidence for multiple competencies, but each claim needs its own justification. There are no stage scores or points; the course competency guide explains how claims are assessed.

## Competency assessment and submission

## The supplied project

Open `aegis` in Godot 4 and run the `Laboratory` scene. It provides:

- Shields that take damage and recharge after a delay.
- Kinetic, Energy, and Arcane damage types.
- Shield and projectile specifications, factories, and equipment power limits.
- A reproducible sequence of 5–10 projectiles, including charge timing and results.
- Basic controls and status information for running the test.

You don't need to implement these systems from scratch. Read the code, run a few experiments, and work out where your changes should go.

Press Tab or X on a controller to show or hide the console. You can also use its + / − button.

Press F to fire a random projectile or Space to run the loaded test sequence. Both options are available from the console’s dropdown and FIRE SELECTED button.

The console displays shield capacity, recharge progress, and the charge status of active projectiles.

Damage is calculated as `projectile_damage * type_factor`:

| Projectile type | Kinetic shield | Energy shield | Arcane shield |
|:---|---:|---:|---:|
| Kinetic | 1 | 0.5 | 2 |
| Energy | 2 | 1 | 0.5 |
| Arcane | 0.5 | 2 | 1 |

The factory specifications are:

| Shield property | Range |
|:---|:---|
| Capacity (`max_capacity`) | 50–250 |
| Recharge delay (`recharge_delay`) | 0.5–5 seconds |
| Recharge rate (`recharge_rate`) | 1–25 points/second |
| Type | Kinetic, Energy, Arcane |

| Projectile property | Range |
|:---|:---|
| Damage | 1–50 |
| Charge time (`charge_time`) | 0.5–3 seconds |
| Type | Kinetic, Energy, Arcane |

The equipment ratings are:

```text
shield_rating = max_capacity + (5.0 - recharge_delay) * 5.0 + recharge_rate * (recharge_rate / 2.0)
projectile_rating = damage * 2.0 + (3.0 - charge_time) ** 4.0
```

The shield rating limit is **300**; the projectile rating limit is **100**. You may change the rules if your design requires it. Document the changes and their effects. The original test should continue to run unless replacing its behavior is part of your extension.

### Scene and scripts

The `Laboratory` scene contains the test environment, the shield apparatus, and the weapon apparatus. The shield spawns at the shield apparatus; the weapon fires projectiles from its projectile spawn point.

Scripts relevant to this exercise include:

* [Shield](aegis/scripts/shield.gd): capacity, damage handling, visual feedback, and the unfinished recharge behavior for Stage 1.
* [Projectile](aegis/scripts/projectile.gd): projectile properties, charge timer, movement, and collision.
* [ShieldSpec](aegis/scripts/shield_spec.gd) and [ProjectileSpec](aegis/scripts/projectile_spec.gd): data holders for the specifications.
* [Effects](aegis/scripts/effects.gd): the effect types and colors. The kinetic enum member is spelled `KENETIC` in the supplied project.
* [Laboratory](aegis/scripts/laboratory.gd): the laboratory's firing behavior.
* [DamageIndicator](aegis/scripts/damage_indiciator.gd): the damage display shown when a projectile hits a shield.

The project autoloads `effects` and `signals`.


## Choose your competencies

The examples below are starting points, not required features. Pick at least two competencies to pursue at Developed.

### Game Design Reasoning — Add a mechanic

The laboratory can destroy a shield. The question is whether doing so makes for an interesting game.

Add a mechanic, or substantially revise an existing one, so that the player has a new decision to make. It should involve a tradeoff and affect something already in Aegis: recharge, damage types, charge timing, manufacturing, or the test sequence.

For example, overcharging could trade more damage for a longer charge time. A combination system could make projectile order matter. A shield could adapt to repeated damage types. You aren't limited to these ideas.

Adding another projectile color isn't a mechanic. Neither is doubling every damage value. What does the player get to decide, and why might they choose differently from one situation to another?

Read Salen and Zimmerman, [*Rules of Play*, Chapter 3, “Meaningful Play”](https://www.creativegames.org.uk/modules/Intro_Game_Studies/Salen_Zimmerman-Rules_of_Play_Chapter3_2003.pdf), particularly discernible and integrated consequences.

**Developed:** Implement your mechanic and explain the choice it creates. Show **two situations** in which different choices have different consequences. Relate your design to the reading, identify the relevant code, and discuss at least one tradeoff or weakness.

### Design Context — Adapt Aegis to a context

Choose a genre, platform, audience, or other play context and make Aegis fit it. Find a concrete precedent, such as an existing game, and study what players actually do in it. Copying its visual style isn't enough.

A tactical adaptation might reveal the upcoming attacks and let players plan. An arcade adaptation might reward well-timed interventions. A management game might ask players to budget power between manufacturing, firing, and defense.

Implement **at least two context-driven design decisions**, with **at least one affecting gameplay or interaction** rather than appearance. Explain how the precedent informed those choices and describe an alternative you considered but didn't use. Show us the results in the project and point to the code.

Apperley's [“Genre and Game Studies” (2006)](https://doi.org/10.1177/1046878105282278) is a useful reading here. If your context isn't primarily about genre, use another relevant course reading and identify it in your write-up.

### System Interrelations — Coordinate existing systems

Implement a behavior that involves **at least three existing systems**. Decide which system owns each part of the behavior, how information passes between them, and what happens if the expected sequence is interrupted.

You could have the test schedule respond to the shield's current state and observed damage. Or share a power budget across the factories, weapon charging, and shield recharge. Another option is to let the outcome of one test determine the specifications manufactured for the next.

Use the existing scenes, nodes, and signals where they make sense. Don't maintain several copies of the same state or recalculate damage in different places.

For **Developed**, show the feature working and identify the **three or more systems** involved. Explain their responsibilities and interfaces; a small diagram is fine. Demonstrate a normal run and a troublesome one—for example, an interrupted test, insufficient power, an invalid specification, or conflicting events—and show that the systems remain consistent.

Relevant course material: components, Godot nodes/signals, and Nystrom's [*Game Programming Patterns*: Observer](https://gameprogrammingpatterns.com/observer.html).

### Interaction Design — Improve the operator's controls

*The test works. The operator would like some idea of what it's doing.*

Find something the operator needs to control or understand and build an interaction around it. A sequence editor, damage explanation, comparison between tests, or mid-test intervention would all be reasonable directions.

Pay attention to what happens before and after an action: when is it available, how does the interface acknowledge it, what changed, and what happens if the player tries something invalid? Connect your interface to actual game state. A panel of hard-coded values won't do.

Have **someone unfamiliar with your implementation** try the interaction. For **Developed**, demonstrate normal use and at least one awkward or invalid case. Explain a specific design decision, report something you observed during the tryout, and describe what you would change (or changed) as a result.

Use at least one principle from Nielsen's [“10 Usability Heuristics for User Interface Design”](https://www.nngroup.com/articles/ten-usability-heuristics/). Swink's *Game Feel* is another option for interactions involving timing and responsiveness.

## Claiming more than one competency

One feature can support multiple claims. For example, a projectile-sequence editor with a heat mechanic could demonstrate Interaction Design through the editor and Game Design Reasoning through the consequences of attack order. A shared heat budget that changes factories, charging, and scheduling might also demonstrate System Interrelations.

You still need to show **distinct evidence** for each competency. The same feature isn't automatically evidence for all the competencies it touches.
