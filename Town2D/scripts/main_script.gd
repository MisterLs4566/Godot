extends Node

func _ready():
	RenderingServer.set_default_clear_color(Color("6a994e", 1))
	
func _process(delta):
	pass


func _on_town_button_pressed():
	get_tree().change_scene_to_file("res://scenes/pomodoro_scene.tscn")
