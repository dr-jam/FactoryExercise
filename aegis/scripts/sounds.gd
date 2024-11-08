class_name Sounds
extends Node3D


func _ready() -> void:
	signals.fire.connect(_on_projectile_fire)
	signals.damage.connect(_on_damage)
	signals.spotlight_on.connect(_on_spotlight_on)
	signals.shield_down.connect(_on_shield_down)


func _on_projectile_fire(type:Effects.Type) -> void:
	if type == Effects.Type.KENETIC:
		$Environment/KeneticFire.play()
	if type == Effects.Type.ENERGY:
		$Environment/EnergyFire.play()
	if type == Effects.Type.ARCANE:
		$Environment/ArcaneFire.play()
	$SadOS/Fire.play()
	

func _on_damage(_value:float, _type:Effects.Type) -> void:
	if randf() < 0.25:
		$SadOS/Damage.play()


func _on_spotlight_on() -> void:
	$Environment/SpotlightOn.play()


func _on_shield_down() -> void:
	$Environment/ShieldDown.play()
	$SadOS/ShieldDown.play()
