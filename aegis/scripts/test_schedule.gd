class_name TestSchedule
extends Node

signal schedule_started
signal projectile_added(index: int, projectile: Projectile)
signal schedule_finished(completed: bool)

var is_running := false
var _cancel_requested := false


func run_schedule(projectiles: Array[Projectile], projectile_parent: Node3D) -> bool:
	if is_running:
		push_error("Cannot start a test schedule while another schedule is running.")
		return false
	if (
		not is_inside_tree()
		or not is_instance_valid(projectile_parent)
		or not projectile_parent.is_inside_tree()
		or projectile_parent.get_tree() != get_tree()
	):
		push_error("The schedule and projectile parent must be inside the same scene tree.")
		return false
	if projectiles.is_empty():
		push_error("A test schedule requires at least one projectile.")
		return false

	var scheduled_ids := {}
	for projectile in projectiles:
		if not is_instance_valid(projectile):
			push_error("A test schedule cannot contain a freed projectile.")
			return false
		if scheduled_ids.has(projectile.get_instance_id()):
			push_error("A projectile cannot appear more than once in a schedule.")
			return false
		if projectile.get_parent() != null:
			push_error("Scheduled projectiles must not already have a parent.")
			return false
		if projectile.charge_time < 0.0:
			push_error("Projectile charge times cannot be negative.")
			return false
		scheduled_ids[projectile.get_instance_id()] = true

	is_running = true
	_cancel_requested = false
	schedule_started.emit()

	for index in range(projectiles.size()):
		if _cancel_requested:
			break

		var projectile := projectiles[index]
		projectile_parent.add_child(projectile)
		projectile_added.emit(index, projectile)
		await get_tree().create_timer(projectile.charge_time).timeout

	var completed := not _cancel_requested
	is_running = false
	schedule_finished.emit(completed)
	return completed


func cancel_schedule() -> void:
	if is_running:
		_cancel_requested = true
