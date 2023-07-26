extends KinematicBody2D

var player
signal explosion
var explosionSound
var enemyExplosionStream2D

func _ready():
	player = get_node("../Player")
	enemyExplosionStream2D = get_node("Stream2DExplosion")

func _process(delta):
	if position.distance_to(player.position) < 1000:
		look_at(player.position)
		rotation_degrees += 90
	
	if(visible == false and enemyExplosionStream2D.playing == false):
		queue_free()

func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Explosion":
		visible = false
		$CollisionShape2D.disabled = true

func _on_Enemy_explosion():
	enemyExplosionStream2D.play()
