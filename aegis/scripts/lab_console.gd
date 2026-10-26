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
@onready var _shield_capacity: Label = %ShieldCapacity
@onready var _capacity_bar: ProgressBar = %CapacityBar
@onready var _recharge_status: Label = %RechargeStatus
@onready var _recharge_bar: ProgressBar = %RechargeBar
@onready var _projectile_status: Label = %ProjectileStatus
@onready var _projectile_list: VBoxContainer = %ProjectileList
@onready var _projectile_scroll: ScrollContainer = %ProjectileScroll
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


func update_shield_status(shield: Shield) -> void:
	_shield_status.text = "SHIELD / " + effects.get_type_name(shield.type)
	_shield_capacity.text = "%.1f / %.1f" % [shield.current_level, shield.max_capacity]
	_capacity_bar.max_value = shield.max_capacity
	_capacity_bar.value = shield.current_level
	_capacity_bar.tooltip_text = "Current shield capacity / maximum capacity"

	_recharge_bar.value = 0.0
	if shield.is_depleted():
		_recharge_status.text = "Depleted"
	elif shield.current_level >= shield.max_capacity:
		_recharge_status.text = "Fully charged"
		_recharge_bar.value = 1.0
	elif shield.is_recharging():
		_recharge_status.text = "Regenerating  +%.1f / s" % shield.recharge_rate
		_recharge_bar.value = shield.current_level / shield.max_capacity
	else:
		var remaining := shield.get_recharge_delay_remaining()
		_recharge_status.text = "Recharge in %.1f s" % remaining
		if shield.recharge_delay > 0.0:
			_recharge_bar.value = 1.0 - remaining / shield.recharge_delay
	_recharge_bar.tooltip_text = "Recharge delay elapsed; capacity restored while regenerating"


func update_projectile_status(projectiles: Array[Projectile]) -> void:
	_projectile_status.text = "PROJECTILES / %d active" % projectiles.size()
	_projectile_scroll.visible = not projectiles.is_empty()
	if projectiles.is_empty():
		_projectile_status.text = "PROJECTILES / Idle"

	while _projectile_list.get_child_count() > projectiles.size():
		var row := _projectile_list.get_child(_projectile_list.get_child_count() - 1)
		_projectile_list.remove_child(row)
		row.queue_free()

	for index in projectiles.size():
		if index >= _projectile_list.get_child_count():
			_add_projectile_row()
		var row := _projectile_list.get_child(index)
		var title := row.get_node("Title") as Label
		var status := row.get_node("Status") as Label
		var bar := row.get_node("Charge") as ProgressBar
		var projectile := projectiles[index]
		title.text = "%s   /   %.1f damage" % [
			effects.get_type_name(projectile.type), projectile.damage,
		]
		bar.value = 1.0
		status.text = "In flight"
		if projectile.is_charging():
			var remaining := projectile.get_charge_time_remaining()
			status.text = "Charging   %.1f / %.1f s" % [remaining, projectile.charge_time]
			if projectile.charge_time > 0.0:
				bar.value = 1.0 - remaining / projectile.charge_time
		bar.tooltip_text = "Charge progress (remaining / total time); full when in flight"


func _add_projectile_row() -> void:
	var row := VBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	var title := Label.new()
	title.name = "Title"
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	row.add_child(title)
	var status := Label.new()
	status.name = "Status"
	status.add_theme_font_size_override("font_size", 11)
	row.add_child(status)
	var bar := ProgressBar.new()
	bar.name = "Charge"
	bar.custom_minimum_size.y = 6.0
	bar.max_value = 1.0
	bar.step = 0.001
	bar.show_percentage = false
	row.add_child(bar)
	_projectile_list.add_child(row)


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
