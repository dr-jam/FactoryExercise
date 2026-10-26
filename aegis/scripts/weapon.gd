class_name Weapon
extends StaticBody3D

@export var projectile_factory: ProjectileFactory

func fire_default(type:Effects.Type, damage:float) -> void:
	LabLog.test("Ad hoc fire commencing.")
	if projectile_factory == null:
		LabLog.error("Cannot fire without a projectile factory.")
		return
	var spec := ProjectileSpec.new()
	spec.damage = damage
	spec.type = type
	var new_projectile := projectile_factory.build(spec)
	if new_projectile != null:
		fire(new_projectile)

func fire(projectile_to_shoot:Projectile) -> void:
	$ProjectileSpawn.add_child(projectile_to_shoot)


func get_active_projectiles() -> Array[Projectile]:
	var active_projectiles: Array[Projectile] = []
	for child in $ProjectileSpawn.get_children():
		if child is Projectile and not child.is_queued_for_deletion():
			active_projectiles.append(child)
	return active_projectiles
