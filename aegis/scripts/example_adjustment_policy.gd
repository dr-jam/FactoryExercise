class_name ExampleAdjustmentPolicy
extends RefCounted

## A baseline policy to read, run, and improve for Stage 3.2.
##
## For projectiles, preserve charge time by reducing damage when needed.
## For shields, preserve capacity and recharge delay by reducing recharge rate.
## This meets the budgets but can make hits weaker or shield recovery slower.
##
## Inputs must already satisfy the Stage 3.1 ranges, as EvaluationBatch inputs do.
## The policy changes and returns the supplied spec. Copy it first if you need to
## retain the original request. PolicyEvaluationRunner makes those copies for you.
##
## Usage (my_policy is a method you write that handles both spec types):
##   var batch := EvaluationBatch.generate(42)
##   var results := PolicyEvaluationRunner.compare(
##       batch, ExampleAdjustmentPolicy.adjust, my_policy
##   )
##
## Reuse adjustment logic in your factories. For the optional pathway, compare
## this baseline with your own policy, measure a goal, and revise your policy.
## Calling this example alone is not evidence of your own policy design.


## Adjust either supported spec type. Unsupported inputs log an error and return null.
static func adjust(specification: RefCounted) -> RefCounted:
	if specification is ProjectileSpec:
		return _adjust_projectile(specification)
	if specification is ShieldSpec:
		return _adjust_shield(specification)

	push_error("ExampleAdjustmentPolicy accepts only ShieldSpec and ProjectileSpec inputs.")
	return null


static func _adjust_projectile(specification: ProjectileSpec) -> ProjectileSpec:
	# damage * 2 + charge_cost <= 100, so damage <= (100 - charge_cost) / 2.
	var charge_cost := pow(3.0 - specification.charge_time, 4.0)
	var damage_budget := (100.0 - charge_cost) / 2.0
	specification.damage = minf(specification.damage, damage_budget)
	return specification


static func _adjust_shield(specification: ShieldSpec) -> ShieldSpec:
	# rate squared / 2 must fit the budget left after capacity and delay costs.
	var delay_cost := (5.0 - specification.recharge_delay) * 5.0
	var recharge_budget := 300.0 - specification.max_capacity - delay_cost
	var maximum_rate := sqrt(2.0 * recharge_budget)
	specification.recharge_rate = minf(specification.recharge_rate, maximum_rate)
	return specification
