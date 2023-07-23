extends KinematicBody2D

var speed = 500
var velocity = Vector2()
var rot = 1
signal shoot
var slowDown = false

func _ready():
	pass
	
func input():
	if Input.is_action_just_pressed("ui_right"):
		rotation_degrees += 45
		if rot < 8:
			rot += 1
		else:
			rot = 1
	if Input.is_action_just_pressed("ui_left"):
		rotation_degrees -= 45
		if rot > 1:
			rot -= 1
		else:
			rot = 8
	if Input.is_action_just_pressed("ui_up"):
		slowDown = false
		"""Animation setzen"""
		$AnimatedSprite.play("Movement")
		if rot == 1:
			 velocity.x = 0 
			 velocity.y = -1
		elif rot == 2:	
			velocity.x = 1
			velocity.y = -1
		elif rot == 3:
			velocity.x = 1
			velocity.y = 0
		elif rot == 4:
			velocity.x = 1
			velocity.y = +1
		elif rot == 5:	
			velocity.x = 0
			velocity.y = +1
		elif rot == 6:
			velocity.x = -1
			velocity.y = +1
		elif rot == 7:
			velocity.x = -1
			velocity.y = 0
		elif rot == 8:	
			velocity.x = -1
			velocity.y = -1
	if Input.is_action_just_pressed("ui_down"):
		$AnimatedSprite.play("Idle")
		slowDown = true
	if Input.is_action_just_released("ui_accept"):
		emit_signal("shoot")
	
	
func _process(delta):
	input()
	if slowDown == false:
		move_and_slide(velocity.normalized() * speed)
	else:
		move_and_slide(velocity.normalized() * speed/2)
