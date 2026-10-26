class_name TestSequencer
extends Node


@export var projectile_sequence: Array[ProjectileSpec]
@export var shield:ShieldSpec


var _current_projectile: Projectile
var _testing := false
var _remaining_projectiles: Array[ProjectileSpec] = []


func _physics_process(_delta: float) -> void:
	if _testing and _current_projectile == null:
		_fire_next_projectile()


func run_test_sequence() -> void:
	if _testing:
		LabLog.test("A test sequence is already running.")
		return
	if shield == null or projectile_sequence.size() < 5 or projectile_sequence.size() > 10:
		LabLog.test("The test requires a shield and a sequence of 5-10 projectiles.")
		return

	var built_shield: Shield = %ShieldFactory.build(shield)
	if built_shield == null:
		return

	_remaining_projectiles = projectile_sequence.duplicate()
	_testing = true
	_fire_next_projectile()


func _fire_next_projectile() -> void:
	if _remaining_projectiles.is_empty():
		LabLog.test("Test sequence terminated.")
		_testing = false
		_current_projectile = null
		return

	var projectile_spec: ProjectileSpec = _remaining_projectiles.pop_front()
	_current_projectile = %ProjectileFactory.build(projectile_spec)
	if _current_projectile == null:
		_testing = false
		_remaining_projectiles.clear()
		return
	%WeaponApparatus.fire(_current_projectile)
