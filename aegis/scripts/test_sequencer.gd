class_name TestSequencer
extends Node


@export var projectile_sequence: Array[ProjectileSpec]
@export var shield:ShieldSpec


var _current_projectile : Projectile
var _testing : bool = false


func _physics_process(delta: float) -> void:
	if _testing:
		if null == _current_projectile:
			if projectile_sequence.is_empty():
				LabLog.test("Test sequence terminated.")
				_testing  = false
			else:
			# get a new projectile
				_current_projectile = %ProjectileFactory.build(projectile_sequence.pop_front())
				%WeaponApparatus.fire(_current_projectile)
			



func run_test_sequence():
	# initialize the shield and fire the first projectile
	%ShieldFactory.build(shield)
	
	_current_projectile = %ProjectileFactory.build(projectile_sequence.pop_front())
	%WeaponApparatus.fire(_current_projectile)
	#for projectile_spec in projectile_sequence:
		#var projectile = %ProjectileFactory.build(projectile_spec)
		#%WeaponApparatus.fire(projectile)

	_testing = true
