## The class that represents the lab space and is the defacto agent.

# This class is imporant to the exercise. This is heart of the game's
# decision-making. Testing, coordinated reactions, and assingnment criteria
# like TestFactories generating and running TestSchedules should be handled
# here.


class_name Laboratory
extends Node3D

@onready var shield:Shield = $ShieldApparatus
@onready var weapon:Weapon = $WeaponAparatus

@onready var north_light:StaggerLight = $Surveillance/NorthSpotLight
@onready var east_light:StaggerLight = $Surveillance/EastSpotLight
@onready var south_light:StaggerLight = $Surveillance/SouthSpotLight
@onready var west_light:StaggerLight = $Surveillance/WestSpotLight


func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		weapon.fire(Effects.Type.values().pick_random(), randf_range(5.0, 20.0))

func _start_lights():
	north_light.start_delay()
	east_light.start_delay()
	south_light.start_delay()
	west_light.start_delay()
