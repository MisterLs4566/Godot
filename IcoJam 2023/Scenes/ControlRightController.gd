extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "_on_ControlRight_pressed")

func _on_ControlLeft_pressed():
	Input.action_press("ui_right")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
