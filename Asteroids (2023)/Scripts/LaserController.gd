extends KinematicBody2D

var speed = 0
var velocity = Vector2()
var oldPosition = Vector2()
var player
var isShooting = false
var maxDistance = 350
var audioPlayer

var collision
var collisionCollider

var laserSound
var explosionSound
var explosionSoundEnemy

var volume

signal explosion
var laserStream2D
var laserExplosionStream2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	laserStream2D = get_node("Stream2DLaser")
	laserExplosionStream2D = get_node("Stream2DLaserExplosion")
	
	laserSound = preload("res://Sounds/Laser1FireSound.wav")
	explosionSound = preload("res://Sounds/Laser1ExplosionSound.wav")
	explosionSoundEnemy = preload("res://Sounds/Enemy1Explosion.wav")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity.rotated(rotation).normalized() * speed)
	
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
	if isShooting == true:
		if (position.distance_to(oldPosition) > maxDistance):
			"""Stoppen wenn am Explodieren?"""
			#velocity = Vector2.ZERO
			$AnimatedSprite.play("Explosion")
			emit_signal("explosion")
			
func _on_Player_shoot():
	if isShooting == false:
		laserStream2D.play()
		$AnimatedSprite.play("default")	
		position = player.position
		oldPosition = position
		isShooting = true
		speed = 2000
		rotation_degrees = player.rotation_degrees
		visible = true
		velocity.y = -1

func _on_AnimatedSprite_animation_finished():
	if isShooting == true and $AnimatedSprite.get_animation() == "Explosion":
		isShooting = false
		velocity = Vector2.ZERO
		visible = false
		$AnimatedSprite.play("default")	


func _on_Laser_explosion():
	laserExplosionStream2D.stop()
	laserExplosionStream2D.play()
