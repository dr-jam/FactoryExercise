class_name DamageIndicator
extends Label3D

@export var duration:float = 3.0
@export var end_location:Node3D
@export var movement_curve:Curve

var damage:float = 999

var _timer:Timer
var _elapsed_time:float = 0.0

func _ready():
	text = str(roundf(damage))
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.start(duration)
	

func _process(delta):
	if _timer != null && !_timer.is_stopped():
		_elapsed_time += delta
		var t:float = _elapsed_time / duration
		position = end_location.position * movement_curve.sample(t)
	if _timer.is_stopped():
		queue_free()


func set_color(color:Color) -> void:
	modulate = color
