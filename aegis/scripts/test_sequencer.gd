class_name TestSequencer
extends Node

signal status_changed(status: String)

@export var projectile_sequence: Array[ProjectileSpec]
@export var shield:ShieldSpec


var _current_projectile: Projectile
var _testing := false
var _remaining_projectiles: Array[ProjectileSpec] = []
var _hits := 0
var _misses := 0


func _physics_process(_delta: float) -> void:
	if _testing and not is_instance_valid(_current_projectile):
		_fire_next_projectile()


func run_test_sequence() -> void:
	if _testing:
		LabLog.test("A test sequence is already running.")
		return
	if shield == null or projectile_sequence.size() < 5 or projectile_sequence.size() > 10:
		_abort("Requires a shield and 5-10 projectiles")
		return
	if projectile_sequence.has(null):
		_abort("Sequence contains an empty projectile specification")
		return

	var built_shield: Shield = %ShieldFactory.build(shield)
	if built_shield == null:
		_abort("Shield construction failed")
		return

	_remaining_projectiles = projectile_sequence.duplicate()
	_hits = 0
	_misses = 0
	_testing = true
	_fire_next_projectile()


func _fire_next_projectile() -> void:
	if _remaining_projectiles.is_empty():
		var result := "Complete / %d hit, %d missed" % [_hits, _misses]
		LabLog.test(result)
		status_changed.emit(result)
		_testing = false
		_current_projectile = null
		return

	var projectile_spec: ProjectileSpec = _remaining_projectiles.pop_front()
	_current_projectile = %ProjectileFactory.build(projectile_spec)
	if _current_projectile == null:
		_abort("Projectile construction failed")
		return
	_current_projectile.resolved.connect(_on_projectile_resolved)
	status_changed.emit("Running / shot %d of %d" % [
		projectile_sequence.size() - _remaining_projectiles.size(),
		projectile_sequence.size(),
	])
	%WeaponApparatus.fire(_current_projectile)


func _on_projectile_resolved(hit: bool) -> void:
	if hit:
		_hits += 1
	else:
		_misses += 1


func _abort(reason: String) -> void:
	_testing = false
	_remaining_projectiles.clear()
	LabLog.error("Test aborted: " + reason)
	status_changed.emit("Aborted / " + reason)
