extends KinematicBody2D

var gravity = 900
var state = 0

func _ready():
	pass
	
func _process(delta):
	move_and_slide(Vector2.DOWN * gravity * state)


func _on_Node2D_resume():
	state = 1


func _on_Node2D_gameStart():
	state = 0
