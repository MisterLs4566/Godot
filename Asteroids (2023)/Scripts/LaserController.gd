extends KinematicBody2D

"""nodes"""

var player

"""variables"""

var speed = 2000
var velocity = Vector2(0, -1)
var oldPosition = Vector2()
var maxDistance = 400


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
	laserSound = preload("res://Sounds/Laser1FireSound.wav")
	explosionSound = preload("res://Sounds/Laser1ExplosionSound.wav")
	explosionSoundEnemy = preload("res://Sounds/Enemy1Explosion.wav")
	oldPosition = position
	"""shoot"""
	rotation_degrees = player.rotation_degrees
	$AudioStream2DLaser.play()
	$AnimatedSprite.play("default")	
	
	"""connect signals"""
	connect("explosion", self, "_on_Laser_explosion")
func collision():
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
			collision = get_slide_collision(i).collider as KinematicBody2D
			collisionCollider = get_slide_collision(i).collider as CollisionObject2D
			if collisionCollider.collision_layer == 2:
				collision.get_child(2).play()
				collision.get_child(0).play("Explosion")
				collision.get_child(1).disabled = true
				velocity = Vector2.ZERO
				$AnimatedSprite.play("Explosion")
				return

func _process(delta):
	move_and_slide(velocity.rotated(rotation).normalized() * speed)
	collision()
	if isShooting == true:
		if (position.distance_to(oldPosition) > maxDistance):
			isShooting = false
			$AnimatedSprite.play("Explosion")
			emit_signal("explosion")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "Explosion":
		player.projectiles -= 1
		if player.projectiles == 0:
			player.laserCooldown = false
		queue_free()
		

func _on_Laser_explosion():
	$AudioStream2DLaserExplosion.play()
	
