class_name ShieldMesh
extends MeshInstance3D

#https://godotshaders.com/shader/energy-shield-with-impact-effect/
#https://github.com/AbstractBorderStudio/energy-shield-shader-with-impact-effect

@export var animation:Curve
@export var impact:Curve
@export var animation_time:float = 3.0

var _material:ShaderMaterial

@onready var _shield:Shield = $".."

func _ready() -> void:
	_material = get_active_material(0)
	set_shield_color_by_type(_shield.type)


func set_shield_color(color:Color) -> void:
	_material.set_shader_parameter("_shield_color", color)


func set_shield_color_by_type(type:Effects.Type) -> void:
	set_shield_color(effects.get_type_color(_shield.type))
