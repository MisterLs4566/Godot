extends KinematicBody2D
export var gravity = 1
export var speed = 10
export var jumpHeight = 10
var velocity = Vector2(0, 0)
var collision
var groundRay
var isGrounded = false

func _ready():
	set_process_input(true)
	groundRay = get_node("groundRay")

func _process(delta):
	_grounded()
	_gravity()

func _grounded():
	if groundRay.is_colliding():
		isGrounded = true
	else:
		isGrounded = false

func _gravity():
	if isGrounded == false:
		velocity.y += gravity

func _physics_process(delta):
	
	collision = move_and_collide(Vector2(velocity.x, velocity.y * gravity) * delta)
	
	if collision:
		velocity = velocity.slide(collision.normal)
		if collision.collider.get_collision_layer() == 2:
			"""Destroy Game Object"""
			#self.queue_free()
			get_tree().reload_current_scene()
			
func _input(ev):
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		get_node("Player").set_flip_h(false)
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		get_node("Player").set_flip_h(true)
	else:
		velocity.x = 0
	
	if Input.is_action_pressed("jump"):
		if isGrounded == true:
			velocity.y = 0
			velocity.y -= jumpHeight;