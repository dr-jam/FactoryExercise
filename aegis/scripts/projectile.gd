class_name Projectile
extends RigidBody3D

const DEFAULT_SPEED:float = 10.0

@export var damage:float = 20.0
@export var charge_time:float = 0.01
@export var type:Effects.Type = Effects.Type.KENETIC
@export var acceleration:Curve

var speed:float = DEFAULT_SPEED

var elapsed_time:float

var _timer:Timer
var _fired = false

@onready var _body:CSGSphere3D = $Body


func _ready():
	elapsed_time = 0.0
	var material:StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = effects.get_type_color(type)
	_body.material_override = material
	
	
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(charge_time)


func _process(delta):
	if _timer.is_stopped():
		if !_fired:
			_fired = true
			signals.fire.emit(type)
		elapsed_time += delta
		linear_velocity.x = -acceleration.sample(elapsed_time) * speed


func _on_body_entered(body):
	if body is Shield:
		signals.shield_hit.emit(body as Shield, self)
		queue_free()
