class_name ShieldFactory
extends Node

const MIN_CAPACITY := 50.0
const MAX_CAPACITY := 250.0
const MIN_RECHARGE_RATE := 1.0
const MAX_RECHARGE_RATE := 25.0
const MIN_RECHARGE_DELAY := 0.5
const MAX_RECHARGE_DELAY := 5.0
const MAX_RATING := 300.0

# This factory exists to retool a shield. Think of it as a shipyard or drydock.
@export var shield_in_factory:Shield


func build(spec:ShieldSpec, shield:Shield = self.shield_in_factory) -> Shield:
	if spec == null:
		LabLog.error("Cannot build a shield without a specification.")
		return null
	if shield == null:
		LabLog.error("Cannot build a shield without a shield instance.")
		return null

	shield.max_capacity = spec.max_capacity
	shield.type = spec.type
	shield.recharge_delay = spec.recharge_delay
	shield.recharge_rate = spec.recharge_rate
	if !_verify(shield):
		_fit_to_constraints(shield)
	shield.reset_for_test()
	return shield


## Determines if the shield is within its rating and individual attribute constraints.
func _verify(shield:Shield) -> bool:
	var rating := (
		shield.max_capacity
		+ (MAX_RECHARGE_DELAY - shield.recharge_delay) * 5.0
		+ shield.recharge_rate * (shield.recharge_rate / 2.0)
	)
	return (
		shield.max_capacity >= MIN_CAPACITY
		and shield.max_capacity <= MAX_CAPACITY
		and shield.recharge_delay >= MIN_RECHARGE_DELAY
		and shield.recharge_delay <= MAX_RECHARGE_DELAY
		and shield.recharge_rate >= MIN_RECHARGE_RATE
		and shield.recharge_rate <= MAX_RECHARGE_RATE
		and Effects.Type.values().has(shield.type)
		and rating <= MAX_RATING
	)


## Modifies the shield to match its rating and attribute constraints.
func _fit_to_constraints(shield:Shield):
	shield.max_capacity = clampf(shield.max_capacity, MIN_CAPACITY, MAX_CAPACITY)
	shield.recharge_delay = clampf(shield.recharge_delay, MIN_RECHARGE_DELAY, MAX_RECHARGE_DELAY)
	shield.recharge_rate = clampf(shield.recharge_rate, MIN_RECHARGE_RATE, MAX_RECHARGE_RATE)
	if not Effects.Type.values().has(shield.type):
		shield.type = Effects.Type.KENETIC

	var rating_without_recharge := (
		shield.max_capacity + (MAX_RECHARGE_DELAY - shield.recharge_delay) * 5.0
	)
	var rate_allowed_by_rating := sqrt((MAX_RATING - rating_without_recharge) * 2.0)
	shield.recharge_rate = minf(shield.recharge_rate, rate_allowed_by_rating)
