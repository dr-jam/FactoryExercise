class_name ProjectileFactory
extends Node


@export var projectile_base: PackedScene


func build(spec: ProjectileSpec) -> Projectile:
	var projectile := projectile_base.instantiate() as Projectile
	projectile.damage = spec.damage
	projectile.type = spec.type
	projectile.charge_time = spec.charge_time
	
	if !_verify(projectile):
		_fit_to_constraints(projectile)
	return projectile


func build_random() -> Projectile:
	var projectile := projectile_base.instantiate() as Projectile

	#stage task

	if !_verify(projectile):
		_fit_to_constraints(projectile)
	return projectile

## Determines if the projectile is withing overall rating and inidividual attribute constraints.
func _verify(suspect_projectile:Projectile) -> bool:
	#stage task
	return true
	
## Modifies the projectile to match the overall rating and attribute constraints.
func _fit_to_constraints(projectile_to_fix:Projectile):
	#stage task
	pass
