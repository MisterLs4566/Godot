extends KinematicBody2D

var player

func _ready():
	player = get_node("../Player")

func _process(delta):
	if position.distance_to(player.position) < 1000:
		look_at(player.position)
		rotation_degrees += 90


func _on_AnimatedSprite_animation_finished():
	if  $AnimatedSprite.get_animation() == "Explosion":
		queue_free()
