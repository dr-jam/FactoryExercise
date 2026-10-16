extends Node

## Project-wide logging singleton with themed, color-coded output for gameplay debugging.
##
## Register this script as an Autoload named `LabLog`.

# Usage:
#   LabLog.info("Player initialized.")
#   LabLog.success("Test completed.")
#   LabLog.failure("Test conditions were not satisfied.")
#   LabLog.warning("Health is low.")
#   LabLog.error("Player could not be spawned.")
#   LabLog.test("Beginning movement test.")
#   LabLog.physics("Player collided with Wall.")
#   LabLog.input("Jump action pressed.")
#   LabLog.ai("Enemy changed state to CHASE.")
#   LabLog.signal_event("Pickup detected Player.")
#   LabLog.weapon("Plasma cannon fired.")
#   LabLog.shield("Shield absorbed 25 damage.")
#
# Optional:
#   LabLog.header("PLAYER MOVEMENT TEST")
#   LabLog.separator()
#   LabLog.blank()
#
# Configuration:
#   LabLog.enabled = true
#   LabLog.commentary_enabled = true
#   LabLog.commentary_probability = 0.12
#   LabLog.timestamps_enabled = false
#   LabLog.rich_text_enabled = true
#   LabLog.file_logging_enabled = true


enum Level {
	INFO,
	SUCCESS,
	FAILURE,
	WARNING,
	ERROR,
	TEST,
	PHYSICS,
	INPUT,
	AI,
	SIGNAL,
	WEAPON,
	SHIELD,
}


const LOG_DIRECTORY := "user://lablogs"

const PREFIXES := {
	Level.INFO: "[FACILITY]",
	Level.SUCCESS: "[TEST SUCCESS]",
	Level.FAILURE: "[TEST FAILURE]",
	Level.WARNING: "[MINOR CONCERN]",
	Level.ERROR: "[UNEXPECTED RESULT]",
	Level.TEST: "[TEST CHAMBER]",
	Level.PHYSICS: "[PHYSICS TEST]",
	Level.INPUT: "[INPUT OBSERVATION]",
	Level.AI: "[BEHAVIORAL ANALYSIS]",
	Level.SIGNAL: "[SIGNAL MONITOR]",
	Level.WEAPON: "[WEAPON SYSTEM]",
	Level.SHIELD: "[SHIELD SYSTEM]",
}

const SYMBOLS := {
	Level.INFO: "●",
	Level.SUCCESS: "✓",
	Level.FAILURE: "✗",
	Level.WARNING: "▲",
	Level.ERROR: "✕",
	Level.TEST: "◆",
	Level.PHYSICS: "◈",
	Level.INPUT: "▶",
	Level.AI: "◇",
	Level.SIGNAL: "↳",
	Level.WEAPON: "⚡",
	Level.SHIELD: "⬢",
}

const COLORS := {
	Level.INFO: "gray",
	Level.SUCCESS: "lime",
	Level.FAILURE: "orange_red",
	Level.WARNING: "yellow",
	Level.ERROR: "red",
	Level.TEST: "orange",
	Level.PHYSICS: "cyan",
	Level.INPUT: "sky_blue",
	Level.AI: "violet",
	Level.SIGNAL: "light_green",
	Level.WEAPON: "orange_red",
	Level.SHIELD: "deep_sky_blue",
}

const COMMENTARY := {
	Level.INFO: [
		"Monitoring continues. For science.",
		"Facility systems remain adequately operational.",
		"This information has been recorded.",
		"No immediate catastrophe detected.",
	],
	Level.SUCCESS: [
		"Competence remains statistically possible.",
		"Unexpectedly acceptable.",
		"Result recorded as technically successful.",
		"The experiment survived your participation.",
	],
	Level.FAILURE: [
		"The test has concluded unsuccessfully.",
		"Performance fell outside acceptable parameters.",
		"The result has been classified as disappointing.",
		"Failure recorded. Please remain available for additional testing.",
		"The facility has updated its expectations accordingly.",
	],
	Level.WARNING: [
		"This was probably preventable.",
		"Please attempt to appear concerned.",
		"The facility has noted your decision.",
		"This outcome was not entirely unforeseen.",
	],
	Level.ERROR: [
		"Fascinating. Another way for this to fail.",
		"This result will require additional testing.",
		"The facility expected slightly more.",
		"That was not part of the approved procedure.",
	],
	Level.TEST: [
		"Please continue. The data is becoming interesting.",
		"Beginning another completely safe experiment.",
		"Try not to disturb the equipment.",
		"Testing remains mandatory.",
	],
	Level.PHYSICS: [
		"Newton remains disappointingly consistent.",
		"Physical reality continues to function.",
		"The collision has been documented.",
	],
	Level.INPUT: [
		"Human intention successfully detected.",
		"The button appears to have survived.",
		"Input received. Eventually.",
	],
	Level.AI: [
		"The artificial intelligence is behaving normally.",
		"Behavioral deviation remains within tolerance.",
		"The machine has made a decision. How reassuring.",
	],
	Level.SIGNAL: [
		"Communication between subsystems confirmed.",
		"Someone appears to be listening.",
		"The message reached its destination.",
	],
	Level.WEAPON: [
		"Weapon discharge recorded.",
		"Offensive capability remains within acceptable parameters.",
		"The target appears to have received the message.",
		"Projectile deployment was statistically adequate.",
	],
	Level.SHIELD: [
		"Defensive field response recorded.",
		"Structural integrity remains temporarily encouraging.",
		"The barrier has absorbed another poor decision.",
		"Protection systems continue to justify their budget.",
	],
}


var enabled := true
var commentary_enabled := true
var commentary_probability := 0.12
var timestamps_enabled := false
var rich_text_enabled := true
var file_logging_enabled := true

var _log_file: FileAccess


func _ready() -> void:
	if file_logging_enabled:
		_open_log_file()


func info(message: Variant) -> void:
	_log(Level.INFO, str(message))


func success(message: Variant) -> void:
	_log(Level.SUCCESS, str(message))


func failure(message: Variant) -> void:
	_log(Level.FAILURE, str(message))


func warning(message: Variant) -> void:
	_log(Level.WARNING, str(message))


func error(message: Variant) -> void:
	_log(Level.ERROR, str(message))


func test(message: Variant) -> void:
	_log(Level.TEST, str(message))


func physics(message: Variant) -> void:
	_log(Level.PHYSICS, str(message))


func input(message: Variant) -> void:
	_log(Level.INPUT, str(message))


func ai(message: Variant) -> void:
	_log(Level.AI, str(message))


func signal_event(message: Variant) -> void:
	_log(Level.SIGNAL, str(message))


func weapon(message: Variant) -> void:
	_log(Level.WEAPON, str(message))


func shield(message: Variant) -> void:
	_log(Level.SHIELD, str(message))


func header(title: String) -> void:
	if not enabled:
		return

	var line := "────────────────────────────────────────"

	if rich_text_enabled:
		print_rich("")
		print_rich("[color=gray]%s[/color]" % line)
		print_rich("[color=orange][b]  SADOS: %s[/b][/color]" % title)
		print_rich("[color=gray]%s[/color]" % line)
	else:
		print("")
		print(line)
		print("  SADOS: %s" % title)
		print(line)

	_write_header_to_file(title)


func separator() -> void:
	if not enabled:
		return

	if rich_text_enabled:
		print_rich("[color=gray]────────────────────────────────────────[/color]")
	else:
		print("----------------------------------------")

	_write_raw_to_file("----------------------------------------")


func blank() -> void:
	if not enabled:
		return

	print("")
	_write_raw_to_file("")


func _log(level: Level, message: String) -> void:
	if not enabled:
		return

	_log_to_console(level, message)
	_log_to_file(level, message)
	_maybe_comment(level)


func _log_to_console(level: Level, message: String) -> void:
	var prefix := _get_prefix(level)
	var symbol := _get_symbol(level)
	var color := _get_color(level)
	var timestamp := _get_console_timestamp()

	var plain_message := "%s%s %s %s" % [
		timestamp,
		symbol,
		prefix,
		message,
	]

	match level:
		Level.WARNING:
			push_warning(plain_message)

		Level.ERROR:
			push_error(plain_message)

		_:
			if rich_text_enabled:
				var rich_message := "%s[color=%s][b]%s %s[/b][/color] %s" % [
					timestamp,
					color,
					symbol,
					prefix,
					message,
				]

				print_rich(rich_message)
			else:
				print(plain_message)


func _log_to_file(level: Level, message: String) -> void:
	if not file_logging_enabled or _log_file == null:
		return

	var timestamp := Time.get_datetime_string_from_system()
	var prefix := _get_prefix(level)

	_log_file.store_line("%s %s %s" % [
		timestamp,
		prefix,
		message,
	])

	_log_file.flush()


func _open_log_file() -> void:
	var dir_error := DirAccess.make_dir_recursive_absolute(LOG_DIRECTORY)

	if dir_error != OK and dir_error != ERR_ALREADY_EXISTS:
		push_error("LabLog could not create log directory: %s" % LOG_DIRECTORY)
		return

	var timestamp := Time.get_datetime_string_from_system()
	var safe_timestamp := timestamp.replace(":", "-")
	var file_path := "%s/lablog_%s.txt" % [
		LOG_DIRECTORY,
		safe_timestamp,
	]

	_log_file = FileAccess.open(file_path, FileAccess.WRITE)

	if _log_file == null:
		push_error("LabLog could not open log file: %s" % file_path)
		return

	_log_file.store_line("SADOS LOG")
	_log_file.store_line("Session started: %s" % timestamp)
	_log_file.store_line("")
	_log_file.flush()


func _write_header_to_file(title: String) -> void:
	if not file_logging_enabled or _log_file == null:
		return

	_log_file.store_line("")
	_log_file.store_line("----------------------------------------")
	_log_file.store_line("SADOS: %s" % title)
	_log_file.store_line("----------------------------------------")
	_log_file.flush()


func _write_raw_to_file(message: String) -> void:
	if not file_logging_enabled or _log_file == null:
		return

	_log_file.store_line(message)
	_log_file.flush()


func _write_comment_to_file(comment: String) -> void:
	if not file_logging_enabled or _log_file == null:
		return

	var timestamp := Time.get_datetime_string_from_system()

	_log_file.store_line("%s [COMMENTARY] %s" % [
		timestamp,
		comment,
	])

	_log_file.flush()


func _get_prefix(level: Level) -> String:
	return PREFIXES.get(level, "[UNKNOWN]")


func _get_symbol(level: Level) -> String:
	return SYMBOLS.get(level, "?")


func _get_color(level: Level) -> String:
	return COLORS.get(level, "white")


func _maybe_comment(level: Level) -> void:
	if not commentary_enabled:
		return

	if randf() > commentary_probability:
		return

	var comment := _get_comment(level)

	if comment.is_empty():
		return

	if rich_text_enabled:
		print_rich("[color=gray][i]    %s[/i][/color]" % comment)
	else:
		print("    %s" % comment)

	_write_comment_to_file(comment)


func _get_comment(level: Level) -> String:
	if not COMMENTARY.has(level):
		return ""

	var options: Array = COMMENTARY[level]

	if options.is_empty():
		return ""

	return options.pick_random()


func _get_console_timestamp() -> String:
	if not timestamps_enabled:
		return ""

	var time := Time.get_time_dict_from_system()

	return "[%02d:%02d:%02d] " % [
		time.hour,
		time.minute,
		time.second,
	]
