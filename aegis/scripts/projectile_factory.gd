class_name ProjectileFactory
extends Node


@export var projectile_base: PackedScene

# build function that takes a spec
# 2nd build that takes rng and a shield spec
# does it need to take rng if we drop the experiment req?


func build(spec: ProjectileSpec) -> Projectile:
	var projectile := projectile_base.instantiate() as Projectile
	projectile.damage = spec.damage
	projectile.type = spec.type
	projectile.charge_time = spec.charge_time
	
	if !_verify(projectile):
		_fit_to_constraints(projectile)
	return null


## Determines if the projectile is withing overall rating and inidividual attribute constraints.
func _verify(projectile:Projectile) -> bool:
	#stage task
	return true
	
## Modifies the projectile to match the overall rating and attribute constraints.
func _fit_to_constraints(projectile:Projectile):
	#stage task
	pass
