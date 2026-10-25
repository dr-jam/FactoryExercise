class_name TestRunRecord
extends RefCounted

## Stores reproducible inputs and named checks from one TestFactory run.
##
## Usage:
##   var report := TestRunRecord.new(seed)
##   report.add_specification(shield_spec)
##   report.check_result("damage", expected_damage, observed_damage)
##   print(report.passed())
##   report.save_json("user://test_run.json")
##
## This class records evidence; TestFactory is responsible for running the test
## and deciding which outcomes to check.

## Seed used to generate the test inputs.
var seed_value: int

## Serialized shield and projectile specs used in this run.
var specifications: Array[Dictionary] = []

## Named expected-versus-observed checks and their pass status.
var results: Array[Dictionary] = []


## Create a report for a run made with [param run_seed].
func _init(run_seed: int = 0) -> void:
	seed_value = run_seed


## Add a [ShieldSpec] or [ProjectileSpec] to the report.
## Returns false for an unsupported spec type.
func add_specification(specification: RefCounted) -> bool:
	var values := _specification_values(specification)
	if values.is_empty():
		return false
	specifications.append(values)
	return true


## Compare expected and observed values and save the result.
## Floating-point values pass when they differ by no more than [param tolerance].
## Returns true when this check passes.
func check_result(
	check_name: String,
	expected: Variant,
	observed: Variant,
	tolerance: float = 0.000001
) -> bool:
	if tolerance < 0.0:
		push_error("Result tolerance cannot be negative.")
		return false

	var passed:bool = expected == observed
	if typeof(expected) in [TYPE_FLOAT, TYPE_INT] and typeof(observed) in [TYPE_FLOAT, TYPE_INT]:
		passed = absf(float(expected) - float(observed)) <= tolerance

	results.append({
		"name": check_name,
		"expected": expected,
		"observed": observed,
		"passed": passed,
	})
	return passed


## Return true if at least one check exists and all checks passed.
func passed() -> bool:
	if results.is_empty():
		return false
	for result in results:
		if not result["passed"]:
			return false
	return true


## Return all report data as a Dictionary, suitable for JSON serialization.
func to_dictionary() -> Dictionary:
	return {
		"seed": seed_value,
		"specifications": specifications,
		"results": results,
		"passed": passed(),
	}


## Save the report under [code]user://[/code].
## Returns [constant OK] on success or a Godot error code on failure.
func save_json(path: String) -> int:
	if not path.begins_with("user://"):
		push_error("Test run reports must be saved under user://.")
		return ERR_INVALID_PARAMETER

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		var open_error := FileAccess.get_open_error()
		push_error("Could not write test run report '%s' (error %d)." % [path, open_error])
		return open_error

	file.store_string(JSON.stringify(to_dictionary(), "\t"))
	var write_error := file.get_error()
	file.close()
	if write_error != OK:
		push_error("Could not finish writing test run report '%s' (error %d)." % [path, write_error])
		return write_error
	return OK


func _specification_values(specification: RefCounted) -> Dictionary:
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

	push_error("TestRunRecord can record only ShieldSpec and ProjectileSpec values.")
	return {}
