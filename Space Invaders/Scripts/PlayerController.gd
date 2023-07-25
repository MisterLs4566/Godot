extends KinematicBody2D

var speed = 500
var velocity = Vector2(0, -1)
signal shoot
signal killed
var slowDown = false
var start = false

func _ready():
	pass
	
func input():
	if Input.is_action_just_pressed("ui_up"):
		slowDown = false
		start = true
		"""Richtung setzen"""
		velocity.x = 0
		velocity.y = -1
		velocity = velocity.rotated(rotation).normalized()
		"""Animation setzen"""
		$AnimatedSprite.play("Movement")
	if Input.is_action_just_pressed("ui_down"):
		$AnimatedSprite.play("Idle")
		slowDown = true
	if Input.is_action_pressed("ui_accept"):
		emit_signal("shoot")
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to(load("res://Scenes/MenuScene.tscn"))
	
	
func _process(delta):
	input()
	look_at(get_global_mouse_position())
	rotation_degrees += 90	
	if start == false:
		return
	if slowDown == false:
		move_and_slide(velocity* speed)
	else:
		move_and_slide(velocity* speed/2)
