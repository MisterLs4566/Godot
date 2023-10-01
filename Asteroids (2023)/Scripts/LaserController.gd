extends KinematicBody2D

"""nodes"""

var source
var player
var playerCooldownTimerSalve

"""variables"""

var strength = 1
var speed = 2000
var velocity = Vector2(0, -1)
var oldPosition = Vector2()
var maxDistance = 400
var target = ""
"""switches"""

var isShooting = true

"""KinematicBody2D"""

var collision

"""CollisionObject2D"""

var collisionCollider

"""preloads"""

var laserSound
var explosionSound
var explosionSoundEnemy

"""signals"""

signal explosion

func _ready():
	player = get_node("/root/Node2D/Player")
	playerCooldownTimerSalve = player.get_node("CooldownTimerSalve")
	laserSound = preload("res://Sounds/Laser1FireSound.wav")
	explosionSound = preload("res://Sounds/Laser1ExplosionSound.wav")
	explosionSoundEnemy = preload("res://Sounds/Enemy1Explosion.wav")
	oldPosition = position
	"""shoot"""
	rotation_degrees = source.rotation_degrees
	$AudioStream2DLaser.play()
	$AnimatedSprite.play("default")	
	"""connect signals"""
	if connect("explosion", self, "_on_Laser_explosion") != OK:
		print("explosion connect in LaserController.gd didn't work")
	if $cooldownTimerLaserDestroyed.connect("timeout", self, "_on_cooldownTimerLaserDestroyed_timeout") != OK:
		print("timeout connect in LaserController didn't work")
func collision(delta):
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
			collision = get_slide_collision(i).collider as KinematicBody2D
			collisionCollider = get_slide_collision(i).collider as CollisionObject2D
			if collision == null:
				return
			if collision.is_in_group(target):
				$CollisionShape2D.disabled = true
				if(target == "Player"):
					collision.emit_signal("hurt", strength, 0.1, 1000, Vector2(position.x, position.y))
				else:
					collision.emit_signal("hurt", strength, 0.1, 1000)
				velocity = Vector2.ZERO
				#checkPlayerCooldown()
				$AnimatedSprite.play("Explosion")
				if maxDistance - position.distance_to(oldPosition) > 0:
					"""t = s/v, damit nicht unendlich viele Laser gleichzeitig abgeschossen werden können"""
					$cooldownTimerLaserDestroyed.wait_time = (maxDistance - position.distance_to(oldPosition)) / (speed)
					$cooldownTimerLaserDestroyed.start()

func _process(delta):
	move_and_slide(velocity.rotated(rotation).normalized() * speed)
	collision(delta)
	if isShooting == true:
		if (position.distance_to(oldPosition) > maxDistance):
			isShooting = false
			checkSourceCooldown()
			$AnimatedSprite.play("Explosion")
			emit_signal("explosion")

func checkSourceCooldown():
	if source.projectiles > 0:
		source.projectiles -= 1
	if source.projectiles == 0:
		source.laserCooldown = false
		source.CooldownTimerSalve.stop()
		#playerCooldownTimerSalve.stop()
		#player.shootKeyPressed = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Explosion":
		#checkSourceCooldown() #eigentlich die Einstellung für den cooldown (cooldown erst aufgehoben, wenn Laser gelöscht)
							   # =>checkSourceCooldown an anderen Stellen im Code entfernen
		visible = false
		

func _on_Laser_explosion():
	$AudioStream2DLaserExplosion.play()
func _on_cooldownTimerLaserDestroyed_timeout():
	checkSourceCooldown()
	queue_free()
