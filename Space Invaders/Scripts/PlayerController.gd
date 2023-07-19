extends KinematicBody2D

var speed = 300
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func input():
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	#velocity = velocity.normalized() * speed
	
func _process(delta):
	input()
	velocity = velocity.normalized() * delta * speed
	move_and_collide(velocity)
	velocity = Vector2.ZERO
