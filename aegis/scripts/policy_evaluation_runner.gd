class_name PolicyEvaluationRunner
extends RefCounted

## Compares two factory adjustment policies on the same requests.
##
## Use this for the optional Evaluation and Iteration pathway after Stage 3.2.
## Start with [ExampleAdjustmentPolicy] and write an alternative that reuses your
## factory adjustment logic. Each policy must accept
## either a [ShieldSpec] or a [ProjectileSpec] and return an adjusted spec or a
## non-empty Dictionary summary.
##
## Usage from your test scene script (my_policy is a method you write):
##   var specifications := EvaluationBatch.generate(42)
##   var results := PolicyEvaluationRunner.compare(
##       specifications, ExampleAdjustmentPolicy.adjust, my_policy
##   )
##   for row in results:
##       print("Requested: ", row["input"])
##       print("Policy A: ", row["policy_a"])
##       print("Policy B: ", row["policy_b"])
##
## Run the scene from the Godot editor to see the output. Check each policy's
## results against the specification ranges, rating limits, and your chosen goal.
## Revise one policy and repeat with the same batch to measure whether it improved.
##
## This helper collects outputs; it does not calculate ratings, choose a winner,
## or test constructed shields and projectiles in the scene.


## Runs both policies on separate copies of each input and returns a side-by-side report.
## Policies may adjust their copies without changing the batch or each other's inputs.
## Each returned row has [code]input[/code], [code]policy_a[/code], and
## [code]policy_b[/code] Dictionaries containing the requested and returned values.
## Invalid inputs or unsupported policy results log an error and return an empty array.
static func compare(
	specifications: Array[RefCounted],
	policy_a: Callable,
	policy_b: Callable
) -> Array[Dictionary]:
	if not policy_a.is_valid() or not policy_b.is_valid():
		push_error("Policy comparison requires two valid policy callables.")
		return []
	if specifications.is_empty():
		push_error("Policy comparison requires at least one specification.")
		return []

	for specification in specifications:
		if not specification is ShieldSpec and not specification is ProjectileSpec:
			push_error("Policy comparison accepts only ShieldSpec and ProjectileSpec inputs.")
			return []

	var results: Array[Dictionary] = []
	for specification in specifications:
		var result_a: Variant = policy_a.call(_copy_specification(specification))
		var result_b: Variant = policy_b.call(_copy_specification(specification))
		var record_a := _result_to_dictionary(result_a)
		var record_b := _result_to_dictionary(result_b)
		if record_a.is_empty() or record_b.is_empty():
			return []

		results.append({
			"input": _specification_to_dictionary(specification),
			"policy_a": record_a,
			"policy_b": record_b,
		})

	return results


static func _copy_specification(specification: RefCounted) -> RefCounted:
	# Give the policies independent inputs; their adjustment must not affect the batch.
	if specification is ShieldSpec:
		var source := specification as ShieldSpec
		var copy := ShieldSpec.new()
		copy.max_capacity = source.max_capacity
		copy.recharge_rate = source.recharge_rate
		copy.recharge_delay = source.recharge_delay
		copy.type = source.type
		return copy

	if specification is ProjectileSpec:
		var source := specification as ProjectileSpec
		var copy := ProjectileSpec.new()
		copy.damage = source.damage
		copy.charge_time = source.charge_time
		copy.type = source.type
		return copy

	push_error("Policy comparison accepts only ShieldSpec and ProjectileSpec inputs.")
	return null


static func _specification_to_dictionary(specification: RefCounted) -> Dictionary:
	if specification is ShieldSpec:
		var shield_spec := specification as ShieldSpec
		return {
			"kind": "shield",
			"max_capacity": shield_spec.max_capacity,
			"recharge_rate": shield_spec.recharge_rate,
			"recharge_delay": shield_spec.recharge_delay,
			"type": shield_spec.type,
		}

	if specification is ProjectileSpec:
		var projectile_spec := specification as ProjectileSpec
		return {
			"kind": "projectile",
			"damage": projectile_spec.damage,
			"charge_time": projectile_spec.charge_time,
			"type": projectile_spec.type,
		}

	push_error("Cannot serialize a specification other than ShieldSpec or ProjectileSpec.")
	return {}


static func _result_to_dictionary(result: Variant) -> Dictionary:
	if typeof(result) == TYPE_DICTIONARY:
		return result.duplicate(true)
	if result is ShieldSpec or result is ProjectileSpec:
		return _specification_to_dictionary(result)

	push_error("Factory policies must return an adjusted spec or a Dictionary summary.")
	return {}
