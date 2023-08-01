extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color(0, 0, 0))

func _on_Button_pressed():
	get_tree().change_scene_to(load("res://Scenes/Level01.tscn"))
