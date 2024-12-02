class_name ShieldMesh
extends MeshInstance3D

#https://godotshaders.com/shader/energy-shield-with-impact-effect/
#https://github.com/AbstractBorderStudio/energy-shield-shader-with-impact-effect

@export var animation:Curve
@export var impact:Curve
@export var animation_time:float = 3.0

var _material : ShaderMaterial
var elapsed_time : float = 0.0
var animate : bool  = false
var fade_duration : float = 0.5

@onready var _shield:Shield = $".."

func _ready() -> void:
	_material = get_active_material(0)
	set_shield_color_by_type(_shield.type)
	signals.shield_hit.connect(_on_projectile_impact)

func _process(delta: float) -> void:
	if animate:
		if elapsed_time < animation_time:
			elapsed_time += delta
			var normalize_time: float = elapsed_time / animation_time
			var impact_anim = impact.sample(normalize_time) * animation_time
			_material.set_shader_parameter("_impact_anim", impact_anim)
			_material.set_shader_parameter("_impact_anim_max", animation_time)
			_material.set_shader_parameter("_impact_fade_duration", fade_duration)
		else:
			_material.set_shader_parameter("_impact_anim", 0.0)
			elapsed_time = 0.0
			animate = false
	else: # second check so animation of impact remains 0
		_material.set_shader_parameter("_impact_anim", 0.0)
		


func set_shield_color(color:Color) -> void:
	_material.set_shader_parameter("_shield_color", color)


func set_shield_color_by_type(type:Effects.Type) -> void:
	set_shield_color(effects.get_type_color(_shield.type))


func set_impact_origin(pos: Vector3) -> void:
	_material.set_shader_parameter("_impact_origin", pos)
	_material.set_shader_parameter("_impact_anim", 0.0)
	animate = true
	elapsed_time = 0.0


func _on_projectile_impact(_x, projectile:Projectile) -> void:
	var proj_position = projectile.global_position
	set_impact_origin(proj_position)
