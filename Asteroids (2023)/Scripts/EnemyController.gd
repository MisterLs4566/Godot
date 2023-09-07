extends KinematicBody2D

"""nodes"""
var player
var enemyExplosionStream2D

"""switches"""

var shootPossible = false

"""variables"""

var maxPlayerDistance = 1000
var lives = 3
var fireCooldown
var cooldownSalve = 0.1

"""3 Sekunden Cooldown für den Laser, wenn Player in Sichtfeld des Enemy kommt"""
var laserCooldown = 3
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
var laserInstance

func _ready():
	player = get_node("/root/Node2D/Player")
	laserInstance = preload("res://Prefabs/Laser.tscn")
	$EnemyHealthLabel.set_as_toplevel(true)
	
	"""connect signals"""
	
	connect("explosion", self, "_on_Enemy_explosion")
	connect("hurt", self, "_on_Enemy_hurt")
	$CooldownHurtTimer.connect("timeout", self, "_on_CooldownHurtTimer_timeout")
	$CooldownStartShootTimer.connect("timeout", self, "_on_CooldownStartShootTimer")
func _process(delta):
	"""update health label"""
	$EnemyHealthLabel.rect_position.x = position.x - 40
	$EnemyHealthLabel.rect_position.y = position.y - 160
	
	$EnemyHealthLabel.text = str(lives)
	"""rotate toward player"""
	if position.distance_to(player.position) < maxPlayerDistance:
		look_at(player.position)
		rotation_degrees += 90
		if shootPossible == false:
			$CooldownStartShootTimer.wait_time = laserCooldown
			$CooldownStartShootTimer.start()
		else:
			if $CooldownTimerSalve.is_stopped() == true:
				$CooldownTimerSalve.wait_time = cooldownSalve
				$CooldownTimerSalve.start()
				instanciateLaser(laserInstance, laserMaxDistance, laserSpeed, laserStrength)
				
	"""delete if not existing"""
	
	if(visible == false and $Stream2DExplosion.playing == false):
		queue_free()

func instanciateLaser(laserObject, maxDistance, speed, strength):
	pass
	
func _on_CooldownStartShootTimer():
	print("shootPossible")

func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Hurt":
		$AnimatedSprite.play("Idle")
	if  $AnimatedSprite.get_animation() == "Explosion":
		visible = false
		$CollisionShape2D.disabled = true

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
