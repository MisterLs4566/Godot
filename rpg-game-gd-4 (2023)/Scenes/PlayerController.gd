extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func input():
	if Input.is_action_pressed("ui_right"):
		position.x += 0.1
		$AnimatedSprite2D.play("walking_right")
	elif Input.is_action_pressed("ui_left"):
		position.x -= 0.1
		$AnimatedSprite2D.play("walking_left")
	else:
		$AnimatedSprite2D.play("idle2")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input()
