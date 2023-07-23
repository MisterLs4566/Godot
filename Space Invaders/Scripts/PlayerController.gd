extends KinematicBody2D

var speed = 500
var velocity = Vector2()
signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func input():
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_just_released("ui_accept"):
		emit_signal("shoot")
	
	
func _process(delta):
	input()
	velocity = velocity.normalized() * speed * delta
	move_and_collide(velocity)
	velocity = Vector2.ZERO


func _on_Button_pressed():
	print("test")
