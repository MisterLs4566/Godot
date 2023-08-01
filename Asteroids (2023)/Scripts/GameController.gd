extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0))
	"""Lautstärke"""
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("GameSounds"), 0)
