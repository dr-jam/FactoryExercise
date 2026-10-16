class_name EvaluationBatch
extends RefCounted

## Creates repeatable inputs for comparing factory adjustment policies.
##
## Usage (no EvaluationBatch instance is needed):
##   var seed_value := 42
##   var specifications := EvaluationBatch.generate(seed_value)
##   for specification in specifications:
##       if specification is ShieldSpec:
##           print("Requested shield capacity: ", specification.max_capacity)
##       elif specification is ProjectileSpec:
##           print("Requested projectile damage: ", specification.damage)
##
## Pass the batch and your two policy Callables to [method PolicyEvaluationRunner.compare]
## to compare their outputs. This helper only creates data: it does not build scene
## nodes, adjust specs, calculate ratings, or decide whether a policy is better.
##
## Using this helper for the optional Evaluation and Iteration pathway:
## 1. Use ExampleAdjustmentPolicy as a baseline and write your own alternative,
##    or compare two policies of your own using your Stage 3.2 factory logic.
##    Each policy function must accept either spec type and return an adjusted
##    spec or a Dictionary summary. Reuse your factory's adjustment logic.
## 2. Choose a measurable goal, such as retaining at least 80% of requested
##    projectile damage while meeting the rating limit.
## 3. In a script attached to your test scene, generate a batch with a saved seed.
##    Pass it and your two policy functions to [method PolicyEvaluationRunner.compare].
##    Run the scene from the Godot editor and inspect or display the returned rows.
## 4. For each row, compare the original input with each policy's output. Check
##    the Stage 3.1 ranges and Stage 3.2 rating limits, then measure your goal.
##    Meeting a quality goal does not excuse exceeding the limits.
## 5. Save the results, revise one policy, and repeat with the same seed and count
##    so you compare policies on the same requests rather than different random data.
## 6. Submit the seed, goal, both policies, a before-and-after results table, and
##    a short explanation of whether the revision helped.
##
## Generating a batch alone is not evidence of a successful policy. You implement
## the adjustments, rating checks, measurements, and explanation.

const ShieldSpecType = preload("res://scripts/shield_spec.gd")
const ProjectileSpecType = preload("res://scripts/projectile_spec.gd")


## Returns new [ShieldSpec] and [ProjectileSpec] objects in alternating order,
## starting with a shield. The default count of 12 gives six of each kind.
## [param specification_count] is the total number of specs, not the number of pairs;
## an odd count produces one extra shield.
##
## Reusing [param seed_value] and the same count reproduces the input values.
## Each call creates separate objects, so changes to one batch do not affect another.
## All values are within the Stage 3.1 ranges, but some exceed the Stage 3.2 ratings.
## The first shield and first projectile are always over budget to ensure that
## both kinds of adjustment are exercised.
static func generate(seed_value: int, specification_count: int = 12) -> Array[RefCounted]:
	if specification_count < 2 or specification_count > 50:
		push_error("Evaluation batches must contain between 2 and 50 specifications.")
		return []

	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var specifications: Array[RefCounted] = []

	for index in range(specification_count):
		if index % 2 == 0:
			var shield_spec = ShieldSpecType.new()
			shield_spec.max_capacity = rng.randf_range(50.0, 250.0)
			shield_spec.recharge_delay = rng.randf_range(0.5, 5.0)
			shield_spec.recharge_rate = rng.randf_range(1.0, 25.0)
			shield_spec.type = _random_type(rng)
			if index == 0:
				# Guarantee an over-budget shield regardless of the seed.
				shield_spec.max_capacity = 250.0
				shield_spec.recharge_delay = 0.5
				shield_spec.recharge_rate = 25.0
			specifications.append(shield_spec)
		else:
			var projectile_spec = ProjectileSpecType.new()
			projectile_spec.damage = rng.randf_range(1.0, 50.0)
			projectile_spec.charge_time = rng.randf_range(0.5, 3.0)
			projectile_spec.type = _random_type(rng)
			if index == 1:
				# Guarantee an over-budget projectile regardless of the seed.
				projectile_spec.damage = 50.0
				projectile_spec.charge_time = 0.5
			specifications.append(projectile_spec)

	return specifications


## Chooses an effect type using the batch's seeded generator.
static func _random_type(rng: RandomNumberGenerator) -> Effects.Type:
	match rng.randi_range(0, 2):
		0:
			return Effects.Type.KENETIC
		1:
			return Effects.Type.ENERGY
		2:
			return Effects.Type.ARCANE
	return Effects.Type.KENETIC
