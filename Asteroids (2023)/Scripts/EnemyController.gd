extends KinematicBody2D

"""nodes"""
var player
var enemyExplosionStream2D

"""variables"""

var maxPlayerDistance = 1000
var lives = 3

"""signals"""
signal explosion
signal hurt

func _ready():
	player = get_node("/root/Node2D/Player")
	
	"""connect signals"""
	
	connect("explosion", self, "_on_Enemy_explosion")
	connect("hurt", self, "_on_Enemy_hurt")
func _process(delta):
	"""rotate toward player"""
	if position.distance_to(player.position) < maxPlayerDistance:
		look_at(player.position)
		rotation_degrees += 90
	
	"""delete if not existing"""
	if(visible == false and $Stream2DExplosion.playing == false):
		queue_free()

func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Hurt":
		$AnimatedSprite.play("Idle")
	if  $AnimatedSprite.get_animation() == "Explosion":
		visible = false
		$CollisionShape2D.disabled = true
	
func _on_Enemy_hurt():
	if lives > 1:
		lives -= 1
		$Stream2DHurt.play()
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Hurt")
	else:
		$CollisionShape2D.disabled = true
		emit_signal("explosion")
		$AnimatedSprite.play("Explosion")

func _on_Enemy_explosion():
	$Stream2DExplosion.play()
