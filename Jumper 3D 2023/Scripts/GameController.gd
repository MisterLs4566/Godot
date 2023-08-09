extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#RenderingServer.set_default_clear_color(Color("2fccff"))

func input():
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input()
