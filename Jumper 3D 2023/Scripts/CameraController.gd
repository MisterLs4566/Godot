extends Camera3D

var mouseSensitivity = -0.015
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		rotate(Vector3.UP, event.relative.x * mouseSensitivity)
		rotate_object_local(Vector3.RIGHT, event.relative.y * mouseSensitivity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.x = clamp(rotation.x, -1, 0.6)
