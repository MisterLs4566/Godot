extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_fullscreen = true
	VisualServer.set_default_clear_color(Color(0, 0, 0))
	"""Lautstärke"""
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("GameSounds"), -40)
