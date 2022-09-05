extends KinematicBody2D

export var gravity = 1
var velocity = Vector2(0, 0)
var collision

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	_gravity()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	collision = move_and_collide(Vector2(velocity.x, velocity.y * gravity) * delta)
	
	if collision:
		velocity = velocity.slide(collision.normal)

func _gravity():
	velocity.y += gravity
