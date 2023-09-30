extends KinematicBody2D

var size = 160
"""nodes"""
var scene
var player
var enemyExplosionStream2D
var CooldownTimerSalve
var laserCooldown

"""switches"""

var shootPossible = false

"""variables"""

var maxPlayerDistance = 1000
var lives = 3
var fireCooldown
var cooldownSalve = 0.1

var touchStrength = 3.5
var laserStrength = 1
var laserMaxDistance = 500
var laserSpeed = 2000

var projectiles = 0
var maxProjectiles = 2
var salveCooldown
"""signals"""
signal explosion
signal hurt(strength, knockbackTime, knockbackSpeed)

"""preloads"""
var laser
var laserInstance

func _ready():
	scene = get_node("/root/Node2D")
	player = get_node("/root/Node2D/Player")
	laser = preload("res://Prefabs/Laser.tscn")
	CooldownTimerSalve = $CooldownTimerSalve
	$EnemyHealthLabel.set_as_toplevel(true)
	$EnemyCooldownLabel.set_as_toplevel(true)
	
	"""connect signals"""
	
	connect("explosion", self, "_on_Enemy_explosion")
	connect("hurt", self, "_on_Enemy_hurt")
	$CooldownHurtTimer.connect("timeout", self, "_on_CooldownHurtTimer_timeout")
	$CooldownStartShootTimer.connect("timeout", self, "_on_CooldownStartShootTimer")
func updateUI():
	$EnemyHealthLabel.rect_position.x = position.x - 40
	$EnemyHealthLabel.rect_position.y = position.y - 160
	$EnemyHealthLabel.text = str(lives)
	if shootPossible == false:
		$EnemyCooldownLabel.rect_position.x = position.x - 40
		$EnemyCooldownLabel.rect_position.y = position.y - 220
		if $CooldownStartShootTimer.is_stopped() == false:
			$EnemyCooldownLabel.text = str(int($CooldownStartShootTimer.time_left) + 1);
		else:
			$EnemyCooldownLabel.text = str($CooldownStartShootTimer.wait_time)
func _process(delta):
	"""update ui"""
	updateUI()
	"""rotate towards player"""
	if position.distance_to(player.position) < maxPlayerDistance:
		look_at(player.position)
		rotation_degrees += 90
		if shootPossible == false:
			if ($CooldownStartShootTimer.is_stopped()):
				$CooldownStartShootTimer.start()
		else:
			$CooldownTimerSalve.wait_time = cooldownSalve
			$CooldownTimerSalve.start()
			instanciateLaser(laser, laserMaxDistance, laserSpeed, laserStrength)
			shootPossible = false
				
	"""delete if not existing"""
	
	if(visible == false and $Stream2DExplosion.playing == false):
		queue_free()

func instanciateLaser(laserObject, maxDistance, speed, strength):
	if(projectiles < maxProjectiles and shootPossible == true):
		projectiles += 1
		laserInstance = laserObject.instance()
		laserInstance.set_collision_mask_bit(1, true)
		laserInstance.set_collision_layer_bit(2, true)
		laserInstance.source = self
		laserInstance.maxDistance = maxDistance
		"""Korrektur der Position des Lasers durch einen senkrechten Vektor und Vektoraddition (nicht optimal)"""
		laserInstance.position = position + (Vector2(cos(rotation), sin(rotation)).rotated(deg2rad(-90))) * size/2
		#print(self.position)
		#print(laserInstance.position)
		laserInstance.speed = speed
		laserInstance.strength = laserStrength
		laserInstance.target = "Player"
		laserInstance.oldPosition = position
		#laserInstance.source = self
		scene.add_child(laserInstance)
	
func _on_CooldownStartShootTimer():
	$CooldownStartShootTimer.stop()
	shootPossible = true;

func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Hurt":
		$AnimatedSprite.play("Idle")
	if  $AnimatedSprite.get_animation() == "Explosion":
		visible = false
		$CollisionShape2D.disabled = true
		queue_free()
func _on_Enemy_hurt(strength, knockbackTime, knockbackSpeed):
	if $CooldownHurtTimer.is_stopped() == false:
		return
	$CooldownHurtTimer.start()

	if lives >= 1:
		lives -= strength
		$Stream2DHurt.play()
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Hurt")
	if lives <= 0:
		lives = 0
		$CollisionShape2D.disabled = true
		emit_signal("explosion")
		$AnimatedSprite.play("Explosion")
		
func _on_CooldownHurtTimer_timeout():
	$CooldownHurtTimer.stop()
	
func _on_Enemy_explosion():
	$Stream2DExplosion.play()
