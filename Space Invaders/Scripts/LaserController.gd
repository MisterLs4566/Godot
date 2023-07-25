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

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	laserSound = preload("res://Sounds/Laser1FireSound.wav")
	explosionSound = preload("res://Sounds/Laser1ExplosionSound.wav")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity.rotated(rotation).normalized() * speed)
	
	if isShooting == true:
		if position.distance_to(oldPosition) > maxDistance:
				velocity = Vector2.ZERO
				$AudioStreamPlayer2D.stream = explosionSound
				$AudioStreamPlayer2D.play()
				$AnimatedSprite.play("Explosion")
				return
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
				collision = get_slide_collision(i).collider as KinematicBody2D
				collisionCollider = get_slide_collision(i).collider as CollisionObject2D
				
				if collisionCollider.collision_layer == 2:
					collision.get_child(0).play("Explosion")
					velocity = Vector2.ZERO
					$AudioStreamPlayer2D.stream = explosionSound
					$AudioStreamPlayer2D.play()
					$AnimatedSprite.play("Explosion")

func _on_Player_shoot():
	if isShooting == false:
		$AudioStreamPlayer2D.stream = laserSound
		$AudioStreamPlayer2D.play()
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
		visible = false
		$AnimatedSprite.play("default")	
