extends Node

var speed = 1
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		print("test")
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y -= 1
	
	velocity = velocity.move_toward(velocity, delta * speed)
