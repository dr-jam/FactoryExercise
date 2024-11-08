extends Node

@export var activation_delay:float = 0.0

var _timer:Timer
var _done:bool = true

func _ready() -> void:
	get_parent().visible = false
	start_delay()


func _process(_delta: float) -> void:
	if !_done && _timer.is_stopped():
		signals.spotlight_on.emit()
		_done = true
		get_parent().visible = true


func start_delay() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(activation_delay)
	_done = false
