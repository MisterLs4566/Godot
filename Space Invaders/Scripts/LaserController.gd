extends KinematicBody2D

var speed = 0
var velocity = Vector2()
var oldPosition = Vector2()
var player
var isShooting = false
var maxDistance = 350

var collision
var collisionCollider

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity.rotated(rotation).normalized() * speed)
	
	if isShooting == true:
		if position.distance_to(oldPosition) > maxDistance:
				velocity = Vector2.ZERO
				$AnimatedSprite.play("Explosion")
	if get_slide_count() != 0:
		for i in range(0, get_slide_count()):
				collision = get_slide_collision(i).collider as KinematicBody2D
				collisionCollider = get_slide_collision(i).collider as CollisionObject2D
				
				if collisionCollider.collision_layer == 2:
					collision.queue_free()
					velocity = Vector2.ZERO
					$AnimatedSprite.play("Explosion")

func _on_Player_shoot():
	if isShooting == false:
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
