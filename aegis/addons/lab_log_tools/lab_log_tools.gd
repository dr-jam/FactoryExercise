@tool
extends EditorPlugin

const MENU_ITEM_NAME := "Open Lab Logs"
const LOG_DIRECTORY := "user://lablogs"


func _enter_tree() -> void:
	add_tool_menu_item(MENU_ITEM_NAME, _open_log_directory)


func _exit_tree() -> void:
	remove_tool_menu_item(MENU_ITEM_NAME)


func _open_log_directory() -> void:
	var path := ProjectSettings.globalize_path(LOG_DIRECTORY)

	if not DirAccess.dir_exists_absolute(path):
		var error := DirAccess.make_dir_recursive_absolute(path)

		if error != OK:
			push_error("Could not create LabLog directory: %s" % path)
			return

	var error := OS.shell_open(path)

	if error != OK:
		push_error("Could not open LabLog directory: %s" % path)
