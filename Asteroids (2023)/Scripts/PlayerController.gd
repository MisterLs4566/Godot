extends KinematicBody2D

"""nodes"""
var scene
var laser1
var laserInstance
var laserMaxDistance = 500
var laserSpeed = 2000
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
var maxProjectiles = 1 #10
var cooldownSalve = 0.1 #0.2

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
	laser1 = preload("res://Prefabs/Laser.tscn")
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
		instanciateLaser(laser1, laserMaxDistance, laserSpeed)
	if projectiles < maxProjectiles and maxProjectiles > 1:
		$CooldownTimerSalve.wait_time = cooldownSalve
		$CooldownTimerSalve.start()
	
func instanciateLaser(laserObject, maxDistance, speed):
	if(projectiles < maxProjectiles):
		projectiles += 1
		laserInstance = laserObject.instance()
		laserInstance.maxDistance = maxDistance
		laserInstance.position = position
		scene.add_child(laserInstance)

func input():
	if Input.is_action_just_released("ui_accept"):
		#soll immer direkt die ganze Salbe geschossen werden? => pass
		#/soll es immer möglich sein, auch weniger als die komplette Salbe zu schießen? => untere Zeile wieder aktivieren
		#shootKeyPressed = false
		pass
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
				instanciateLaser(laser1, laserMaxDistance, laserSpeed)
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
		lives -= 1.5
		if(lives <= 0):
			healthLabel.rect_scale.x = 0
			velocity = Vector2.ZERO
			emit_signal("destroyed")
			return
		healthLabel.rect_scale.x = lives
		velocity = Vector2.ZERO
		$AnimatedSprite.play("Hurt")
		
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Hurt":
		hit = false
		$AnimatedSprite.play("Idle")
	elif $AnimatedSprite.get_animation() == "Explosion":
		get_tree().reload_current_scene()

func _on_Player_destroyed():
	$AudioStream2DExplosion.play()
	$AnimatedSprite.play("Explosion")
