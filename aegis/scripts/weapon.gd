class_name Weapon
extends StaticBody3D

@export var projectile:PackedScene

func fire(type:Effects.Type, damage:float) -> void:
	LabLog.test("Ad hoc fire commencing.")
	var new_projectile = projectile.instantiate() as Projectile
	new_projectile.damage = damage
	new_projectile.type = type
	$ProjectileSpawn.add_child(new_projectile)
