extends KinematicBody2D

"""nodes"""
var scene
var healthLabel
var tileMap

"""variables"""
var velocity = Vector2.ZERO
var level
var projectiles = 0
var maxProjectiles = 1  #2 #10 #20 #100
var cooldownSalve = 0.1 #0.2 #0.01
var collisionTile

#Laser:

var laserMaxDistance = 700 #500 #1500
var laserSpeed = 2000
var speed = 500
var knockbackSpeed
var laserStrength = 1

"""switches"""
var slowVelocity = false
var start = false
var hit = false
var shootKeyPressed = false
var laserCooldown = false
var knockback = false
var destroyed = false

var shootPossible = true #sollte eigentlich erst aktiviert werden, wenn der Spieler trigger berührt hat

var lives = 6.5


"""KinematicBody2D"""
var collisionBody

"""CollisionObject2D"""
var collisionCollider

"""Collider"""
var coll

"""preloads"""
var boostSound
var menuScene
var playerExplosionSound
var playerHurtSound
var laser1
var laserInstance

"""signals"""
signal shoot # -> laser
signal hurt(strength, knockbackTime, knockbackSpeed) # -> self
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
	tileMap = get_node("/root/Node2D/TileMap")
	
	"""connect signals"""
	
	connect("destroyed", self, "_on_Player_destroyed")
	connect("hurt", self, "_on_Player_hurt")
	$CooldownTimerSalve.connect("timeout", self, "_on_CooldownTimerSalve_timeout")
	$KnockbackTimer.connect("timeout", self, "_on_KnockbackTimer_timeout")
	$CooldownHurtTimer.connect("timeout", self, "_on_CooldownHurtTimer_timeout")
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	
func _on_CooldownTimerSalve_timeout():
	$CooldownTimerSalve.stop()
	if shootKeyPressed == true and projectiles < maxProjectiles:
		instanciateLaser(laser1, laserMaxDistance, laserSpeed, laserStrength)
	if projectiles < maxProjectiles and maxProjectiles > 1:
		$CooldownTimerSalve.wait_time = cooldownSalve
		$CooldownTimerSalve.start()
	
func instanciateLaser(laserObject, maxDistance, speed, strength):
	if(projectiles < maxProjectiles and shootPossible == true):
		projectiles += 1
		laserInstance = laserObject.instance()
		laserInstance.maxDistance = maxDistance
		laserInstance.position = position
		laserInstance.speed = speed
		laserInstance.strength = laserStrength
		laserInstance.target = "Enemy"
		scene.add_child(laserInstance)

func input():
	if Input.is_action_just_released("ui_accept"):
		#soll immer direkt die ganze Salbe geschossen werden? => pass
		#/soll es immer möglich sein, auch weniger als die komplette Salbe zu schießen? => untere Zeile wieder aktivieren
		if maxProjectiles > 4:
			shootKeyPressed = false
		else:
			pass
	if Input.is_action_just_pressed("ui_up"):
		#if($AudioStream2DBoost.playing == false):
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
				instanciateLaser(laser1, laserMaxDistance, laserSpeed, laserStrength)
				laserCooldown = true
				$CooldownTimerSalve.wait_time = cooldownSalve
				$CooldownTimerSalve.start()
				
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to(menuScene)
		#pass
		
func collision():
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
			coll = get_slide_collision(i).collider
			if(coll.is_in_group("collisionTiles")):
				knockback = true
				emit_signal("hurt", 2.5, 0.1, 1000)
				return
			collisionBody = get_slide_collision(i).collider as KinematicBody2D
			collisionCollider = get_slide_collision(i).collider as CollisionObject2D
			
			if typeof(collisionCollider) != 0:
				if collisionBody.is_in_group("Enemy"):
					emit_signal("hurt", collisionCollider.touchStrength, 0.1, 1000)
			
				
func tileCollision():
	pass

func _process(delta):
	if destroyed == true:
		return
	#print(projectiles)
	
	collision()	
	tileCollision()
	if knockback == true:
		if $AnimatedSprite.get_animation() != "Hurt":
			$AnimatedSprite.stop()
			$AnimatedSprite.play("Hurt")
		velocity.x = 0
		velocity.y = -1
		velocity = velocity.rotated(rotation).normalized()
		move_and_slide(velocity * knockbackSpeed * -1)
		return
	

		
	input()
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	if start == false:
		return
		
	if slowVelocity == false:
		move_and_slide(velocity * speed)
	else:
		move_and_slide(velocity * speed/2)
func getKnockback(time, kSpeed):
	"""Knockback Timer einbauen, Knockback umsetzen"""
	start = false
	knockback = true
	$KnockbackTimer.wait_time = time
	$KnockbackTimer.start()
	knockbackSpeed = kSpeed
	

func _on_KnockbackTimer_timeout():
	$KnockbackTimer.stop()
	knockback = false
func _on_CooldownHurtTimer_timeout():
	$CooldownHurtTimer.stop()
	
func _on_Player_hurt(strength, knockbackTime, knockbackSpeed):
	if $CooldownHurtTimer.is_stopped() == false:
		return
	
	$CooldownHurtTimer.start()
	$AudioStream2DHurt.stop()
	$AudioStream2DHurt.play()
	hit = true
	lives -= strength
	if(lives <= 0):
		healthLabel.rect_scale.x = 0
		velocity = Vector2.ZERO
		emit_signal("destroyed")
		return
	healthLabel.rect_scale.x = lives
	velocity = Vector2.ZERO
	$AnimatedSprite.play("Hurt")
	if knockbackTime > 0:
		getKnockback(knockbackTime, knockbackSpeed)
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Hurt":
		hit = false
		if start == false:
			$AnimatedSprite.play("Idle")
			return
		if slowVelocity == true:
			$AnimatedSprite.play("Idle")
			return
		else:
			$AnimatedSprite.play("Movement")
			return
	elif $AnimatedSprite.get_animation() == "Explosion":
		get_tree().reload_current_scene()

func _on_Player_destroyed():
	knockback = false
	destroyed = true
	$CollisionShape2D.disabled = true
	$AudioStream2DExplosion.play()
	$AnimatedSprite.play("Explosion")
