extends KinematicBody2D

"""nodes"""
var laser
var speed = 500
var healthLabel

"""variables"""
var velocity = Vector2(0, -1)

"""switches"""
var slowVelocity = false
var start = false
var hit = false

var lives = 6.5

"""KinematicBody2D"""
var collision

"""CollisionObject2D"""
var collisionCollider

"""Collider"""
var coll

"""preloads"""
var boostSound
var menuScene

"""signals"""
signal shoot # -> laser
signal hurt # -> self
signal destroyed # -> self

func _ready():
	boostSound = preload("res://Sounds/PlayerFasterSound.wav")
	menuScene = preload("res://Scenes/MenuScene.tscn")
	healthLabel = get_node("/root/Node2D/GameUI/HealthLabel")
	laser = get_node("/root/Node2D/Laser")
	
	"""connect signals"""
	
	connect("destroyed", self, "_on_Player_destroyed")
	connect("hurt", self, "_on_Player_hurt")
	connect("shoot", laser, "_on_Player_shoot")
func input():
	if Input.is_action_just_pressed("ui_up"):
		$AudioStream2DBoost.play()
		slowVelocity = false
		start = true
		"""Richtung setzen"""
		velocity.x = 0
		velocity.y = -1
		velocity = velocity.rotated(rotation).normalized()
		"""Animation setzen"""
		if(hit == false):
			$AnimatedSprite.play("Movement")
	if Input.is_action_just_pressed("ui_down"):
		if(hit == false):
			$AnimatedSprite.play("Idle")
		slowVelocity = true
	if Input.is_action_pressed("ui_accept"):
		emit_signal("shoot")
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to(menuScene)
	
func _process(delta):
	input()
	look_at(get_global_mouse_position())
	rotation_degrees += 90	
	if start == false:
		return
	if slowVelocity == false:
		move_and_slide(velocity * speed)
	else:
		move_and_slide(velocity * speed/2)
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
			collision = get_slide_collision(i).collider as KinematicBody2D
			collisionCollider = get_slide_collision(i).collider as CollisionObject2D
			coll = get_slide_collision(i).collider
			if typeof(collisionCollider) != 0:
				if collisionCollider.collision_layer == 2:
					emit_signal("hurt")
			elif(coll.is_in_group("collisionTiles")):
				emit_signal("hurt")
			else:
				return
				
func _on_Player_hurt():
	if hit == false:
		hit = true
		lives -= 0.5
		healthLabel.rect_scale.x = lives
		velocity = Vector2.ZERO
		$AnimatedSprite.play("Hurt")
		if(lives == 0):
			emit_signal("destroyed")
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Hurt":
		hit = false
		$AnimatedSprite.play("Idle")
	elif $AnimatedSprite.get_animation() == "Explosion":
		get_tree().reload_current_scene()

func _on_Player_destroyed():
	$AnimatedSprite.play("Explosion")
