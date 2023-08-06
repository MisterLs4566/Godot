extends Node2D

"""nodes"""

var startButton

func _ready():
	startButton = get_node("ButtonStart")
	startButton.connect("pressed", self, "_on_Button_pressed")
	VisualServer.set_default_clear_color(Color("#40318d"))

func _on_Button_pressed():
	get_tree().change_scene_to(load("res://Scenes/Level01.tscn"))

func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		_on_Button_pressed()
