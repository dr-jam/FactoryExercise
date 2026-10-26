class_name Weapon
extends StaticBody3D

@export var projectile:PackedScene

func fire_default(type:Effects.Type, damage:float) -> void:
	LabLog.test("Ad hoc fire commencing.")
	var new_projectile = projectile.instantiate() as Projectile
	new_projectile.damage = damage
	new_projectile.type = type
	$ProjectileSpawn.add_child(new_projectile)

func fire(projectile_to_shoot:Projectile) -> void:
	$ProjectileSpawn.add_child(projectile_to_shoot)


func get_active_projectiles() -> Array[Projectile]:
	var active_projectiles: Array[Projectile] = []
	for child in $ProjectileSpawn.get_children():
		if child is Projectile and not child.is_queued_for_deletion():
			active_projectiles.append(child)
	return active_projectiles
