# ECS 179 Programming Exercise 3: The Factory Pattern

*Welcome to the Aegis Testing Initiative. We congratulate you on your selection for a position involving shield technology, projectile technology, and a scientifically acceptable amount of property damage.*

## Competency Claims and Descriptions

Your comptency claims and other information we need to know to best grade your wor

## Learning goals

In this exercise, you will:

* apply the factory design pattern to a small game system
* implement game behavior from specifications, tables, and equations
* test and evaluate the behavior of the system you build

The supplied project is a Godot 4 project written in GDScript. Changes to the test chamber are expected. Changes to the laws of arithmetic are not.

## Competency assessment and submission

Complete the core stages and submit evidence for the competencies below. These are the target levels; assessment depends on your implementation, tests, and explanation.

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
* **Developed:** You can adapt the technique, make and explain your own design decisions, and test a nontrivial case.
* **Mastered:** You can solve a substantial problem independently, compare alternatives and trade-offs, and test normal and failure cases.

The **core stages** are required. You may also submit **up to two additional competency claims** at Developed or Mastered level. The optional pathways below suggest work for Developed claims. For any claim, show what you built, the decisions you made, and how you checked the result; adding a feature alone is not enough.

For each additional claim, provide:

* **Competency:** Which competency are you claiming?
* **Level:** Developed or Mastered.
* **Evidence:** Paths to relevant scripts/scenes/tests and instructions for reproducing a result.
* **Explanation:** Your contribution, the decisions you made, and why the work supports the claimed level.
* **Assistance:** Identify substantial assistance, including help from people or generative AI, and explain your own contribution.

A claim may be accepted at the requested level or a lower level, returned for revision, or found unsupported. Mastered claims may require an individual demonstration or explanation. Follow the course competency guide and your instructor's submission requirements and due dates.

## Provided Godot project

Open the `aegis` directory in Godot and run the project from the editor. It uses GDScript and Compatibility rendering mode. Press **F** to fire a random test projectile, or expand the console and click **Fire**.

### Scene and scripts

The `Laboratory` scene contains the test environment, the shield apparatus, and the weapon apparatus. The shield spawns at the shield apparatus; the weapon fires projectiles from its projectile spawn point.

Scripts relevant to this exercise include:

* [Shield](aegis/scripts/shield.gd): capacity, damage handling, visual feedback, and the unfinished recharge behavior for Stage 1.
* [Projectile](aegis/scripts/projectile.gd): projectile properties, charge timer, movement, and collision.
* [Effects](aegis/scripts/effects.gd): the effect types and colors. The kinetic enum member is spelled `KENETIC` in the supplied project.
* [Laboratory](aegis/scripts/laboratory.gd): the laboratory's firing behavior.
* [DamageIndicator](aegis/scripts/damage_indiciator.gd): the damage display shown when a projectile hits a shield.

The project autoloads `effects` and `signals`. Stage 2 adds the damage calculation service as another autoload.

### Supplied helpers

The starter supplies the helpers below. You implement recharge, damage calculation, the factories, `TestFactory`, and the checks for your tests. You also design your own adjustment policy and, if you choose the console pathway, connect its remaining interactions.

* [ShieldSpec](aegis/scripts/shield_spec.gd) and [ProjectileSpec](aegis/scripts/projectile_spec.gd): data holders for the specifications in Stages 3 and 4.
* [TestSchedule](aegis/scripts/test_schedule.gd): sequential projectile launches with charge-time spacing and cancellation, for Stage 4.
* [TestRunRecord](aegis/scripts/test_run_record.gd): records a seed, specs, and expected-versus-observed checks; saves JSON under `user://`.
* [EvaluationBatch](aegis/scripts/evaluation_batch.gd): generates repeatable inputs, including over-budget requests.
* [ExampleAdjustmentPolicy](aegis/scripts/example_adjustment_policy.gd): a working baseline that reduces projectile damage or shield recharge rate to meet the budget.
* [PolicyEvaluationRunner](aegis/scripts/policy_evaluation_runner.gd): runs two policies on separate copies of the same inputs and collects their outputs.
* [LabConsole](aegis/scenes/lab_console.tscn): a collapsible console with a working random-shot button and signals for the remaining controls.
* [Assessment template](aegis/ASSESSMENT_TEMPLATE.md): a student evidence form and a TA review checklist.

The helper scripts include usage comments. The relevant stages below explain how to use them.

## Core implementation stages

### Stage 1: Shields Online

*The Aegis shield is excellent at absorbing damage. Its present difficulty is remembering that it is supposed to recover afterward. This is a minor issue, according to the department responsible for ordering new shields.*

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

Add the service as an [autoload](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) in Project Settings. You do not need to place it in the laboratory scene. Use it when a projectile hits a shield.

Check the results against the table, including interactions between unlike types.

### Stage 3: Factories and Specifications

Create factories that build shield and projectile nodes from specifications. Use the supplied shield and projectile scenes as a guide.

#### Stage 3.1: Specific Construction

Use the supplied data-only `ShieldSpec` and `ProjectileSpec` classes. Create `ShieldFactory` and `ProjectileFactory`.

Each factory must:

* provide a `build` function that accepts the matching specification and returns a newly instantiated, configured node;
* copy all specified properties to the new node, including its type; and
* provide a random-generation function that accepts a `RandomNumberGenerator` and returns a specification whose values are within the ranges below. This lets `TestFactory` reproduce generated tests from a known seed. For example:
``` GDSCRIPT
var rng := RandomNumberGenerator.new()
rng.seed = 42
var spec := projectile_factory.generate_random(rng)
```

The factory creates the node but does not add it to the scene tree. The caller is responsible for parenting and freeing it.

Specifications must use these ranges:

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

*Your factories have been assigned power budgets. Requests for additional power have been denied. The facility needs the electricity for a different experiment, which is going extremely well and should not be investigated.*

Adjust over-budget specifications before building the equipment. Keep the adjusted values within the Stage 3.1 ranges and use these rating formulas:

`shield_rating = max_capacity + (5.0 - recharge_delay) * 5.0 + recharge_rate * (recharge_rate / 2.0)`

`projectile_rating = damage * 2.0 + (3.0 - charge_time) ** 4.0`

The maximum ratings are **300 for a shield** and **100 for a projectile**. A rating equal to the limit is allowed.

Choose which properties to adjust and explain the trade-off. Read [ExampleAdjustmentPolicy](aegis/scripts/example_adjustment_policy.gd) for one approach, then design your own. Test an in-range specification, an over-budget specification, and one that lands exactly at the limit. Verify the property ranges as well as the ratings.

The optional Evaluation and Iteration pathway asks you to compare and revise policies.

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

Create a `TestFactory` that builds and tests equipment using your Stage 3 factories. Use the supplied `ShieldSpec`, `ProjectileSpec`, and `TestSchedule`. Each test must:

* create one `ShieldSpec` and build its shield
* create between 5 and 10 `ProjectileSpec` values and build their projectiles
* use the supplied `TestSchedule` to launch the projectiles in order, waiting for each projectile's `charge_time` before launching the next
* add the shield and schedule to the scene and run the test
* report whether the test passed, and identify any failed checks

Use a known seed with a `RandomNumberGenerator` and record the seed, specs, expected results, and observed results.

Wait for the projectiles to resolve before evaluating the outcome. The scheduler's `schedule_finished` signal means all launches have been issued; projectiles may still be in flight.

Your checks must cover:

* damage calculated using the Stage 2 table;
* shield levels staying between zero and maximum capacity;
* recharge timing and behavior from Stage 1; and
* factory products meeting the property ranges and rating limits.

Report a pass only when the observed results match the expected results and all applicable checks pass. Submit at least one failing run and one passing run.

Use `TestRunRecord` to save your evidence:

```gdscript
var report := TestRunRecord.new(seed)
report.add_specification(shield_spec)
report.add_specification(projectile_spec)
report.check_result("damage", expected_damage, observed_damage)
print("Test passed: ", report.passed())
var save_error := report.save_json("user://test_run.json")
if save_error != OK:
	push_error("Could not save the test report.")
```

Add every generated spec and each important check. `passed()` is false if there are no checks or if any check fails.

## Optional Developed competency pathways

Choose an optional pathway if you want to submit an additional competency claim. Explain your decisions and show the results.

### Debugging and Testing — extend Stage 4

Choose a nontrivial defect in the actual combat or factory code that you implemented, or use a defect scenario supplied by your instructor. Reproduce it with the `TestFactory`, correct its underlying cause, and add a regression test that fails before the fix and passes afterward. Add tests for at least two boundary or interaction cases, such as:

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

The supplied dropdown starts with “Random test projectile.” Both Fire and F use the same starter function in [Laboratory](aegis/scripts/laboratory.gd): a random effect type and damage between 5 and 20. This demonstration does not use your factories or a fixed seed.

Replace or extend that selection with your own projectile specifications. Call `LabConsole.set_projectile_options()` with descriptive labels, keep the specs in the same order, and replace `Laboratory._on_console_fire_requested()` with code that builds and fires the selected spec through your factory. The signal supplies its zero-based dropdown index.

Connect the controls and status displays to actual game events.

**Evidence:** a functioning console, a concise explanation of the interaction decisions, and a demonstration of the two scenarios addressed.

### Evaluation and Iteration — extend Stage 3.2

Compare two ways to adjust over-budget specs. Both must meet the limits, but they may preserve different qualities of the requested equipment.

Use the supplied evaluation helpers to compare two policies:

1. Generate a batch with `EvaluationBatch.generate(seed)`. It contains 12 specs by default: six shields and six projectiles. The first shield and first projectile are over budget. Save the seed so you can repeat the comparison.
2. Use `ExampleAdjustmentPolicy.adjust` as a baseline and write an alternative, or write two policies of your own. Each function must handle both spec types and return an adjusted spec or a non-empty dictionary summary. Reuse your factory adjustment logic rather than writing a separate demonstration version.
3. Run both policies on the batch with `PolicyEvaluationRunner.compare(...)`. Each policy receives its own copy, so one cannot change the other's input. The result has one row per input: `input`, `policy_a`, and `policy_b`.
4. Choose one measurable goal. For example: “Keep at least 80% of the requested damage while staying under the projectile rating limit.”
5. Compare both results against that goal. Change one policy, run the same batch again, and check whether your change helped.

For example, one policy could reduce projectile damage; another could increase charge time. Check the property ranges and ratings, then measure how well each meets your goal. The runner collects outputs; you calculate the ratings and measurements. A full scene simulation is not required for this comparison.

To compare the example with your alternative, put the following in your test scene script. `my_policy` must be a method you implement, not a supplied method:

```gdscript
var batch := EvaluationBatch.generate(42)
var results := PolicyEvaluationRunner.compare(
    batch, ExampleAdjustmentPolicy.adjust, my_policy
)
for row in results:
    print(row)
```

Run the scene from the Godot editor to inspect the output. The example expects inputs within the Stage 3.1 ranges and modifies the spec it receives; the runner supplies independent copies.

For a request of **50 damage and a 1-second charge**, the example returns **42 damage and the same charge time** (rating 100). For a shield with capacity 250, recharge delay 0.5, and recharge rate 25, it reduces recharge rate to approximately 7.416 (rating approximately 300). Compare these trade-offs with your alternative.

**Submit:** the seed, your goal, both policies, a small before-and-after results table, and a short explanation of whether your revision improved the result.

## Assessment evidence

For each stage or pathway, include:

* the relevant scripts, scenes, and tests;
* steps to reproduce the result from the Godot editor;
* expected and observed results; and
* a short explanation of your design decisions.

Use the [assessment template](aegis/ASSESSMENT_TEMPLATE.md) to organize your submission.