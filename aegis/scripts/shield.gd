class_name Shield
extends RigidBody3D


@export var max_capacity:float = 100.0
@export var recharge_rate:float = 1.0
@export var recharge_delay:float = 1.0
@export var type:Effects.Type = Effects.Type.KENETIC
@export var damage_effect_duration:float = 0.66
@export var damage_effect_scaling:Curve

#The current shield level. Should be between 0 and capacity.
var current_level:float

var _previous_damage:float
var _timer:Timer
var _damage_effect_elapsed:float


@onready var _mesh:ShieldMesh = $ShieldMesh
@onready var _collision_shape:CollisionShape3D = $CollisionShape3D
@onready var _damage_indicator:PackedScene = load("res://scenes/damage_indiciator.tscn")


func _ready():
	current_level = max_capacity
	signals.shield_hit.connect(_on_shield_hit)


func _process(delta):
	#animated shield scale based on damage done
	var new_scale:Vector3 = Vector3.ONE * clampf(current_level / max_capacity, 0.01, 1.0)
	if _timer != null && !_timer.is_stopped():
		_damage_effect_elapsed += delta
		var scale_factor = ((current_level + _previous_damage * damage_effect_scaling.sample(_damage_effect_elapsed / damage_effect_duration)) / max_capacity)
		scale_factor = clampf(scale_factor, 0.01, 1.0)
		new_scale = Vector3.ONE * scale_factor
	_mesh.scale = new_scale
	_collision_shape.scale = new_scale


func _on_shield_hit(_shield:Shield, projectile:Projectile) -> void:
	var previous_current_level = current_level
	current_level = clampf(current_level - projectile.damage, 0, max_capacity)
	var damage_delta = previous_current_level - current_level
	_previous_damage = damage_delta
	
	var new_indicator:DamageIndicator = _damage_indicator.instantiate() as DamageIndicator
	new_indicator.set_color(effects.get_type_color(projectile.type))
	new_indicator.damage = damage_delta
	$Generator.add_child(new_indicator)
	
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(damage_effect_duration)
	_damage_effect_elapsed = 0.0
	
	signals.damage.emit(damage_delta, type)
	
	if is_zero_approx(current_level) && !is_zero_approx(previous_current_level):
		signals.shield_down.emit()
	
