## The class that represents the lab space and is the defacto agent.

# This class is imporant to the exercise. This is heart of the game's
# decision-making. Testing, coordinated reactions, and assingnment criteria
# like TestFactories generating and running TestSchedules should be handled
# here.


class_name Laboratory
extends Node3D

@onready var shield:Shield = $ShieldApparatus
@onready var weapon:Weapon = $WeaponApparatus
@onready var console:LabConsole = $LabConsole

@onready var north_light:StaggerLight = $Surveillance/NorthSpotLight
@onready var east_light:StaggerLight = $Surveillance/EastSpotLight
@onready var south_light:StaggerLight = $Surveillance/SouthSpotLight
@onready var west_light:StaggerLight = $Surveillance/WestSpotLight

@onready var _surveillance_system:Node = $Surveillance

var _cameras:Array[Camera3D]= []


func _ready():
	LabLog.header("INITIALIZING LABORATORY")
	_detect_cameras()
	_start_lights()
	console.fire_requested.connect(_on_console_fire_requested)
	_update_console_status()
	LabLog.info("Laboratory initialization complete.")
	LabLog.separator()


func _process(_delta):
	if(Input.is_action_just_pressed("fire_test_shot")):
		_fire_random_test_shot()
	_update_console_status()


func _update_console_status() -> void:
	console.update_shield_status(shield)
	console.update_projectile_status(weapon.get_active_projectiles())


## Starter wiring for the single default option. Replace this handler with
## specification lookup and factory construction when adding your own options.
func _on_console_fire_requested(projectile_index: int) -> void:
	_fire_from_console_list()


## Shared by F and the console; this ad hoc demonstration is not a seeded test.
func _fire_random_test_shot() -> void:
	LabLog.input("Operator provided fire command.")
	weapon.fire_default(Effects.Type.values().pick_random(), randf_range(5.0, 20.0))

func _fire_from_console_list() -> void:
	var projectile_index = $LabConsole.get_selection()
	#LabLog.test("projectile_index: " + str(projectile_index))
	match projectile_index:
		0:
			_fire_random_test_shot()
		1:
			$TestSequencer.run_test_sequence()


func _detect_cameras():
	LabLog.info("Detecting experimental surveillience apparatus.")
	for child in _surveillance_system.get_children():
		if child is Camera3D:
			_cameras.push_back(child)

func _start_lights():
	LabLog.info("Intializing illunination system.")
	north_light.start_delay()
	east_light.start_delay()
	south_light.start_delay()
	west_light.start_delay()
