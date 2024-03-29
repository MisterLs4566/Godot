extends KinematicBody2D

"""nodes"""
var scene
var healthLabel

var tileMapCollisions
var tileMapCollectables
var tileMapBackground4
var CooldownTimerSalve

"""variables"""
var velocity = Vector2.ZERO
var level
var projectiles = 0
var maxProjectiles = 1  #2 #10 #20 #100
var cooldownSalve = 0.2 #0.2 #0.01
var collisionTile
var laserQueue = 0

#Laser:

var laserMaxDistance = 500 #500 #1500
var laserSpeed = 2000
var speed = 600
var speedStep = 100
var knockbackSpeed
var knockbackVelocity = Vector2.ZERO
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
var oldLives = 6.5
var healthStep = 3

"""KinematicBody2D"""
var collisionBody

"""CollisionObject2D"""
var collisionCollider

"""Collider"""
var coll
var collKnockback

"""preloads"""
var boostSound
var menuScene
var playerExplosionSound
var playerHurtSound
var laser1
var laserInstance

"""signals"""
signal shoot # -> laser
signal hurt(strength, knockbackTime, knockbackSpeed, kSource) # -> self
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
	tileMapCollisions = get_node("/root/Node2D/CollisionTiles")
	
	"""connect signals"""
	
	connect("destroyed", self, "_on_Player_destroyed")
	connect("hurt", self, "_on_Player_hurt")
	CooldownTimerSalve = $CooldownTimerSalve
	
	$CooldownTimerSalve.connect("timeout", self, "_on_CooldownTimerSalve_timeout")
	$KnockbackTimer.connect("timeout", self, "_on_KnockbackTimer_timeout")
	$CooldownHurtTimer.connect("timeout", self, "_on_CooldownHurtTimer_timeout")
	$StopTimer.connect("timeout", self, "_on_StopTimer_timeout")
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
		laserInstance.set_collision_mask_bit(2, true)
		laserInstance.set_collision_layer_bit(1, true)
		laserInstance.source = self
		laserInstance.maxDistance = maxDistance
		laserInstance.position = position
		laserInstance.speed = speed
		laserInstance.strength = laserStrength
		laserInstance.target = "Enemy"
		scene.add_child(laserInstance)

"""Input Abfrage"""

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
		$StopTimer.start()
	if Input.is_action_just_pressed("ui_focus_next"):
		heal(healthStep)
	if Input.is_action_pressed("ui_accept") or laserQueue>=1:
		shootKeyPressed = true
		if projectiles < maxProjectiles:
			if ($CooldownTimerSalve.is_stopped() == true or(projectiles == 0)) and laserCooldown == false:
				if laserQueue>=1:
					laserQueue-=1
				instanciateLaser(laser1, laserMaxDistance, laserSpeed, laserStrength)
				laserCooldown = true
				$CooldownTimerSalve.wait_time = cooldownSalve
				$CooldownTimerSalve.start()
		else:
			#laserQueue = 1
			pass
	if Input.is_action_just_pressed("ui_end"):
		get_tree().change_scene_to(menuScene)
		#pass
func heal(boost):
	$AudioStream2DHealing.play()
	if(lives <= oldLives - healthStep):
		lives += healthStep
	else:
		lives = oldLives
	updateUI()
func collision():
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
			coll = get_slide_collision(i).collider
			if(coll.is_in_group("collisionTiles")):
				knockback = true
				var collSource = Vector2(get_slide_collision(i).position.x, get_slide_collision(i).position.y)
				emit_signal("hurt", 2.5, 0.1, 1000, collSource)
				return
			elif coll.is_in_group("laserSalveCollectable"):
				maxProjectiles = 2  #2 #10 #20 #100
				cooldownSalve = 0.1 #0.2 #0.01
				coll.get_child(1).disabled = true
				coll.queue_free()
				return
			elif coll.is_in_group("HealthCollectable"):
				heal(healthStep)
				coll.get_child(1).disabled = true
				coll.queue_free()
				return
			elif coll.is_in_group("boostCollectable"):
				speed += speedStep
				coll.get_child(1).disabled = true
				coll.queue_free()
				return
			collisionBody = get_slide_collision(i).collider as KinematicBody2D
			collisionCollider = get_slide_collision(i).collider as CollisionObject2D
			if typeof(collisionCollider) != 0:
				if collisionBody.is_in_group("Enemy"):
					emit_signal("hurt", collisionCollider.touchStrength, 0.1, 1000, Vector2(collisionBody.position.x, collisionBody.position.y))
			
func tileCollision():
	pass

func updateUI():
	healthLabel.rect_scale.x = lives

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
		#velocity = velocity.rotated(rotation).normalized()
		velocity = knockbackVelocity.normalized()
		move_and_slide(velocity * knockbackSpeed)
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
"""Richtung des Knockbacks (von der Quelle weg) einbauen"""
func getKnockback(time, kSpeed, kSource):
	"""knockbackDirection einbauen"""
	var vecP = Vector2(position.x, position.y)
	#var vecSource = Vector2(kSource.get_position().x, kSource.get_position().y)
	var vecSource = kSource
	"""knockbackVelocity noch fehlerhaft"""
	knockbackVelocity = vecP - vecSource
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
	
func _on_Player_hurt(strength, knockbackTime, knockbackSpeed, knockbackSource):
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
		getKnockback(knockbackTime, knockbackSpeed, knockbackSource)
		
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

func _on_StopTimer_timeout():
	if not slowVelocity:
		return
	#print(velocity.length())
	velocity /= 2
	if velocity.length() < 0.25:
		velocity = Vector2.ZERO
