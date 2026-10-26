class_name LabConsole
extends CanvasLayer

signal fire_requested(projectile_index: int)
signal collapsed_changed(collapsed: bool)

@export var start_collapsed := true

@onready var _panel: PanelContainer = $Panel
@onready var _content: VBoxContainer = $Panel/Margin/VBox
@onready var _toggle_button: Button = %ToggleButton
@onready var _projectile_selector: OptionButton = %ProjectileSelector
@onready var _shield_status: Label = %ShieldStatus
@onready var _projectile_status: Label = %ProjectileStatus
@onready var _test_status: Label = %TestStatus

var _collapsed := false
var _expanded_bottom_offset: float


func _ready() -> void:
	_expanded_bottom_offset = _panel.offset_bottom
	_set_collapsed(start_collapsed)


## Replaces the default demonstration option. Keep your specs in this order and
## replace Laboratory's starter fire-request handler to build the selected spec.
func set_projectile_options(options: Array[String]) -> void:
	_projectile_selector.clear()
	_projectile_selector.tooltip_text = ""
	for option in options:
		_projectile_selector.add_item(option)


func set_shield_status(status: String) -> void:
	_shield_status.text = "SHIELD  /  " + status


func set_projectile_status(status: String) -> void:
	_projectile_status.text = "PROJECTILE  /  " + status


func set_test_status(status: String) -> void:
	_test_status.text = "TEST SEQUENCE  /  " + status


func get_selection() -> int:
	return _projectile_selector.selected


func _on_fire_pressed() -> void:
	fire_requested.emit(_projectile_selector.selected)


func _on_toggle_pressed() -> void:
	_set_collapsed(not _collapsed)


func _set_collapsed(collapsed: bool) -> void:
	_collapsed = collapsed
	for child in _content.get_children():
		if child.name != "Header":
			child.visible = not _collapsed

	_toggle_button.text = "+" if _collapsed else "-"
	_toggle_button.tooltip_text = "Restore console" if _collapsed else "Collapse console"
	collapsed_changed.emit(_collapsed)

	if _collapsed:
		call_deferred("_fit_collapsed_panel")
	else:
		_panel.offset_bottom = _expanded_bottom_offset


func _fit_collapsed_panel() -> void:
	if _collapsed:
		_panel.offset_bottom = _panel.offset_top + _panel.get_combined_minimum_size().y
