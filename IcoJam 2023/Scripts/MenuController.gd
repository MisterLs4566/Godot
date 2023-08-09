extends Node2D

var click

func _ready():
	VisualServer.set_default_clear_color(Color("#df7126"))

func _on_StartButton_pressed():
	get_tree().change_scene_to(load("res://Scenes/GameScene.tscn"))
