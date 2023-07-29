extends KinematicBody2D

var gravity = 900
var state = 0
var type
var coll

func _ready():
	if get_groups()[0] == "Circle":
		type = "circle"
	elif get_groups()[0] == "Rect":
		type = "rect"
	elif get_groups()[0] == "Heart":
		type = "heart"

func _process(delta):
	move_and_slide(Vector2.DOWN * gravity * state)

func _on_Node2D_resume():
	state = 1

func _on_Node2D_gameStart():
	state = 1
