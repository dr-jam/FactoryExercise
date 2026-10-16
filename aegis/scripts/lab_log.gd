extends Node

enum Level {
	INFO,
	SUCCESS,
	WARNING,
	ERROR,
	TEST,
	PHYSICS,
	INPUT,
	AI,
	SIGNAL,
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
}

var enabled := true
var commentary_enabled := true
var commentary_probability := 0.12
var timestamps_enabled := false
var rich_text_enabled := true


func info(message: Variant) -> void:
	_log(Level.INFO, str(message))


func success(message: Variant) -> void:
	_log(Level.SUCCESS, str(message))


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


func header(title: String) -> void:
	if not enabled:
		return

	var line := "────────────────────────────────────────"

	if rich_text_enabled:
		print_rich("")
		print_rich("[color=gray]%s[/color]" % line)
		print_rich("[color=orange][b]  APERTURE LABORATORY: %s[/b][/color]" % title)
		print_rich("[color=gray]%s[/color]" % line)
	else:
		print("")
		print(line)
		print("  APERTURE LABORATORY: %s" % title)
		print(line)


func separator() -> void:
	if not enabled:
		return

	if rich_text_enabled:
		print_rich("[color=gray]────────────────────────────────────────[/color]")
	else:
		print("----------------------------------------")


func blank() -> void:
	if enabled:
		print("")


func _log(level: Level, message: String) -> void:
	if not enabled:
		return

	var prefix := _get_prefix(level)
	var symbol := _get_symbol(level)
	var color := _get_color(level)
	var timestamp := _get_timestamp()
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

	_maybe_comment(level)


func _get_prefix(level: Level) -> String:
	match level:
		Level.INFO:
			return "[FACILITY]"
		Level.SUCCESS:
			return "[TEST SUCCESS]"
		Level.WARNING:
			return "[MINOR CONCERN]"
		Level.ERROR:
			return "[UNEXPECTED RESULT]"
		Level.TEST:
			return "[TEST CHAMBER]"
		Level.PHYSICS:
			return "[PHYSICS TEST]"
		Level.INPUT:
			return "[INPUT OBSERVATION]"
		Level.AI:
			return "[BEHAVIORAL ANALYSIS]"
		Level.SIGNAL:
			return "[SIGNAL MONITOR]"
		_:
			return "[UNKNOWN]"


func _get_symbol(level: Level) -> String:
	match level:
		Level.INFO:
			return "●"
		Level.SUCCESS:
			return "✓"
		Level.WARNING:
			return "▲"
		Level.ERROR:
			return "✕"
		Level.TEST:
			return "◆"
		Level.PHYSICS:
			return "◈"
		Level.INPUT:
			return "▶"
		Level.AI:
			return "◇"
		Level.SIGNAL:
			return "↳"
		_:
			return "?"


func _get_color(level: Level) -> String:
	match level:
		Level.INFO:
			return "gray"
		Level.SUCCESS:
			return "lime"
		Level.WARNING:
			return "yellow"
		Level.ERROR:
			return "red"
		Level.TEST:
			return "orange"
		Level.PHYSICS:
			return "cyan"
		Level.INPUT:
			return "sky_blue"
		Level.AI:
			return "violet"
		Level.SIGNAL:
			return "light_green"
		_:
			return "white"


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


func _get_comment(level: Level) -> String:
	if not COMMENTARY.has(level):
		return ""

	var options: Array = COMMENTARY[level]

	if options.is_empty():
		return ""

	return options.pick_random()


func _get_timestamp() -> String:
	if not timestamps_enabled:
		return ""

	var time := Time.get_time_dict_from_system()

	return "[%02d:%02d:%02d] " % [
		time.hour,
		time.minute,
		time.second,
	]
