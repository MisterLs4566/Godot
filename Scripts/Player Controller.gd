extends KinematicBody2D

export var gravity = 1
export var speed = 10
export var jumpHeight = 10
var velocity = Vector2(0, 0)
var collision

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true) # Replace with function body.

func _process(delta):
	_gravity()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	collision = move_and_collide(Vector2(velocity.x, velocity.y * gravity) * delta)
	
	if collision:
		velocity = velocity.slide(collision.normal)

func _gravity():
	velocity.y += gravity

func _input(ev):
	if Input.is_key_pressed(KEY_D):
		velocity.x = speed
	elif Input.is_key_pressed(KEY_A):
		velocity.x = -speed
	else:
		velocity.x = 0
	
	if Input.is_key_pressed(KEY_SPACE):
		velocity.y -= jumpHeight;
