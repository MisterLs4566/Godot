extends AnimatedSprite

func _ready():
	connect("animation_finished", get_parent(), "_on_AnimatedSprite_animation_finished")
