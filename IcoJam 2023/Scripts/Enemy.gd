extends KinematicBody2D

var gravity = 900

func _ready():
	pass
	
func _process(delta):
	move_and_slide(Vector2.DOWN * gravity)
