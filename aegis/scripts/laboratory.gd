class_name Laboratory
extends Node3D

@onready var shield:Shield = $ShieldApparatus
@onready var weapon:Weapon = $WeaponAparatus


func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		weapon.fire(Effects.Type.values().pick_random(), randf_range(5.0, 20.0))
