extends KinematicBody2D

"""nodes"""
var scene
var laser
var laserInstance
var speed = 500
var healthLabel

"""variables"""
var velocity = Vector2.ZERO
var level
var projectiles = 0

"""switches"""
var slowVelocity = false
var start = false
var hit = false
var shootKeyPressed = false
var laserCooldown = false

var lives = 6.5
var maxProjectiles = 10 #2
var cooldownSalve = 0.2

"""KinematicBody2D"""
var collision

"""CollisionObject2D"""
var collisionCollider

"""Collider"""
var coll

"""preloads"""
var boostSound
var menuScene
var playerExplosionSound
var playerHurtSound

"""signals"""
signal shoot # -> laser
signal hurt # -> self
signal destroyed # -> self

func _ready():
	velocity = Vector2(0, -1)
	level = 1
	boostSound = preload("res://Sounds/PlayerBoostSound.wav")
	menuScene = preload("res://Scenes/MenuScene.tscn")
	playerExplosionSound = preload("res://Sounds/PlayerExplosionSound.wav")
	playerHurtSound = preload("res://Sounds/PlayerHurtSound.wav")
	laser = preload("res://Prefabs/Laser.tscn")
	healthLabel = get_node("/root/Node2D/GameUI/HealthLabel")
	scene = get_node("/root/Node2D")
	
	"""connect signals"""
	
	connect("destroyed", self, "_on_Player_destroyed")
	connect("hurt", self, "_on_Player_hurt")
	$CooldownTimerSalve.connect("timeout", self, "_on_CooldownTimerSalve_timeout")
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
func _on_CooldownTimerSalve_timeout():
	$CooldownTimerSalve.stop()
	if shootKeyPressed == true and projectiles < maxProjectiles:
		instanciateLaser()
	if projectiles < maxProjectiles:
		$CooldownTimerSalve.wait_time = cooldownSalve
		$CooldownTimerSalve.start()
	
func instanciateLaser():
	projectiles += 1
	laserInstance = laser.instance()
	laserInstance.position = position
	scene.add_child(laserInstance)

func input():
	if Input.is_action_just_released("ui_accept"):
		shootKeyPressed = false
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
		shootKeyPressed = true
		if projectiles < maxProjectiles:
			if ($CooldownTimerSalve.is_stopped() == true or(projectiles == 0)) and laserCooldown == false:
				instanciateLaser()
				laserCooldown = true
				$CooldownTimerSalve.wait_time = cooldownSalve
				$CooldownTimerSalve.start()
				
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to(menuScene)

func collision():
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

func _process(delta):
	#print(projectiles)
	input()
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	collision()	
	if start == false:
		return
	if slowVelocity == false:
		move_and_slide(velocity * speed)
	else:
		move_and_slide(velocity * speed/2)
	
				
func _on_Player_hurt():
	if hit == false:
		$AudioStream2DHurt.stop()
		$AudioStream2DHurt.play()
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
	$AudioStream2DExplosion.play()
	$AnimatedSprite.play("Explosion")
