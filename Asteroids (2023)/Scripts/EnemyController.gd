extends KinematicBody2D

"""nodes"""
var player
var enemyExplosionStream2D
var maxPlayerDistance

"""signals"""
signal explosion

func _ready():
	player = get_node("/root/Node2D/Player")
	enemyExplosionStream2D = get_node("Stream2DExplosion")
	maxPlayerDistance = 1000
	
	"""connect signals"""
	
	connect("explosion", self, "_on_Enemy_explosion")
func _process(delta):
	"""rotate toward player"""
	if position.distance_to(player.position) < maxPlayerDistance:
		look_at(player.position)
		rotation_degrees += 90
	
	"""delete if not existing"""
	if(visible == false and enemyExplosionStream2D.playing == false):
		queue_free()

func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Explosion":
		visible = false
		$CollisionShape2D.disabled = true

func _on_Enemy_explosion():
	enemyExplosionStream2D.play()
