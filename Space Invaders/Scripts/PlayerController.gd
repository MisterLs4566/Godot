extends KinematicBody2D

var speed = 500
var velocity = Vector2(0, -1)
signal shoot
signal killed
signal hurt
var slowDown = false
var start = false
var lives = 6.5
var healthLabel
var hit = false
var collision
var collisionCollider
var fasterSound

func _ready():
	healthLabel = get_node("../GameUI").get_child(1)
	fasterSound = preload("res://Sounds/PlayerFasterSound.wav")
	
func input():
	if Input.is_action_just_pressed("ui_up"):
		$AudioStreamPlayer2D.set_stream(fasterSound)
		$AudioStreamPlayer2D.play()
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
		
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
				collision = get_slide_collision(i).collider as KinematicBody2D
				collisionCollider = get_slide_collision(i).collider as CollisionObject2D
				if typeof(collisionCollider) != 0:
					if collisionCollider.collision_layer == 2:
						emit_signal("hurt")
				else:
					return
func _on_Player_hurt():
	if hit == false:
		hit = true
		lives -= 0.5
		healthLabel.rect_scale.x = lives
		velocity = Vector2.ZERO
