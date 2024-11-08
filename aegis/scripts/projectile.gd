class_name Projectile
extends RigidBody3D

const DEFAULT_SPEED:float = 10.0

@export var damage:float = 20.0
@export var type:Effects.Type = Effects.Type.KENETIC
@export var acceleration:Curve

var speed:float = DEFAULT_SPEED

var elapsed_time:float

@onready var _body:CSGSphere3D = $Body


func _ready():
	elapsed_time = 0.0
	#var material:StandardMaterial3D = _body.material_override
	var material:StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = effects.get_type_color(type)
	_body.material_override = material
	signals.fire.emit(type)


func _process(delta):
	elapsed_time += delta
	linear_velocity.x = -acceleration.sample(elapsed_time) * speed


func _on_body_entered(shield:Shield):
	signals.shield_hit.emit(shield, self)
	queue_free()
