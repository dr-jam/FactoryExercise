class_name Effects
extends Node

enum Type {
	KENETIC,
	ENERGY,
	ARCANE,
}


var _effect_colors:Array[EffectColor]


func _ready() -> void:
	_effect_colors.append(preload("res://resources/kenetic_color.tres"))
	_effect_colors.append(preload("res://resources/energy_color.tres"))
	_effect_colors.append(preload("res://resources/arcane_color.tres"))


func get_type_color(type:Type) -> Color:
	for effect_color in _effect_colors:
		if type == effect_color.type:
			return effect_color.color
	printerr("Couldn't finde color for type " + str(type) + ". Returning default color of WHITE.")
	return Color.WHITE
