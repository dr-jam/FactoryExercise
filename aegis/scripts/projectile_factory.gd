class_name ProjectileFactory
extends Node

const MIN_DAMAGE := 1.0
const MAX_DAMAGE := 50.0
const MIN_CHARGE_TIME := 0.5
const MAX_CHARGE_TIME := 3.0
const MAX_RATING := 100.0

@export var projectile_base: PackedScene


func build(spec: ProjectileSpec) -> Projectile:
	if spec == null:
		LabLog.error("Cannot build a projectile without a specification.")
		return null
	var projectile := _instantiate_projectile()
	if projectile == null:
		return null

	projectile.damage = spec.damage
	projectile.type = spec.type
	projectile.charge_time = spec.charge_time

	if !_verify(projectile):
		_fit_to_constraints(projectile)
	return projectile


func build_random() -> Projectile:
	var projectile := _instantiate_projectile()
	if projectile == null:
		return null

	projectile.damage = randf_range(MIN_DAMAGE, MAX_DAMAGE)
	projectile.charge_time = randf_range(MIN_CHARGE_TIME, MAX_CHARGE_TIME)
	projectile.type = Effects.Type.values().pick_random()

	if !_verify(projectile):
		_fit_to_constraints(projectile)
	return projectile


func _instantiate_projectile() -> Projectile:
	if projectile_base == null:
		LabLog.error("Cannot build a projectile without a projectile scene.")
		return null
	var projectile := projectile_base.instantiate() as Projectile
	if projectile == null:
		LabLog.error("The projectile scene root must use the Projectile script.")
	return projectile


## Determines if the projectile is within its rating and attribute constraints.
func _verify(suspect_projectile:Projectile) -> bool:
	var rating := (
		suspect_projectile.damage * 2.0
		+ pow(3.0 - suspect_projectile.charge_time, 4.0)
	)
	return (
		suspect_projectile.damage >= MIN_DAMAGE
		and suspect_projectile.damage <= MAX_DAMAGE
		and suspect_projectile.charge_time >= MIN_CHARGE_TIME
		and suspect_projectile.charge_time <= MAX_CHARGE_TIME
		and Effects.Type.values().has(suspect_projectile.type)
		and rating <= MAX_RATING
	)


## Modifies the projectile to match its rating and attribute constraints.
func _fit_to_constraints(projectile_to_fix:Projectile):
	projectile_to_fix.damage = clampf(projectile_to_fix.damage, MIN_DAMAGE, MAX_DAMAGE)
	projectile_to_fix.charge_time = clampf(
		projectile_to_fix.charge_time,
		MIN_CHARGE_TIME,
		MAX_CHARGE_TIME
	)
	if not Effects.Type.values().has(projectile_to_fix.type):
		projectile_to_fix.type = Effects.Type.KENETIC

	var rating := (
		projectile_to_fix.damage * 2.0
		+ pow(3.0 - projectile_to_fix.charge_time, 4.0)
	)
	if rating > MAX_RATING:
		var damage_allowed_by_rating := (
			MAX_RATING - pow(3.0 - projectile_to_fix.charge_time, 4.0)
		) / 2.0
		projectile_to_fix.damage = maxf(
			MIN_DAMAGE,
			minf(projectile_to_fix.damage, damage_allowed_by_rating)
		)
