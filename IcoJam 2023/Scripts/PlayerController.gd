extends RigidBody2D

var speed = 100
var velocity = Vector2.ZERO
var oldPos
var type

func _ready():
	oldPos = position
	type = "Circle"
func input():
	
	"""Animation"""
	
	if (Input.is_action_just_pressed("ui_accept")):
		if($AnimatedSprite.animation == "CircleLeft" or ($AnimatedSprite.animation == "CircleRight")):
			$AnimatedSprite.play("RectRight")
			type = "Rect"
			VisualServer.set_default_clear_color(Color("#135740"))
		elif($AnimatedSprite.animation == "RectLeft" or ($AnimatedSprite.animation == "RectRight")):
			$AnimatedSprite.play("HeartRight")
			type = "Heart"
			VisualServer.set_default_clear_color(Color("#403578"))
		elif($AnimatedSprite.animation == "HeartLeft" or ($AnimatedSprite.animation == "HeartRight")):
			$AnimatedSprite.play("CircleRight")
			type = "Circle"
			VisualServer.set_default_clear_color(Color("#2697f0"))
	
	"""Movement"""
	
	if(Input.is_action_pressed("ui_right")):
		if(velocity == Vector2.LEFT):
			sleeping = true
		velocity = Vector2.RIGHT
		apply_impulse(Vector2.ZERO, velocity * speed)
	elif(Input.is_action_pressed("ui_left")):
		if(velocity == Vector2.RIGHT):
			sleeping = true
		velocity = Vector2.LEFT
		apply_impulse(Vector2.ZERO, velocity * speed)

func _physics_process(delta):
	input()
	
func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.get_animation() == "CircleLeft"):
		$AnimatedSprite.play("CircleRight")
	elif($AnimatedSprite.get_animation() == "CircleRight"):
		$AnimatedSprite.play("CircleLeft")
	elif($AnimatedSprite.get_animation() == "RectLeft"):
		$AnimatedSprite.play("RectRight")
	elif($AnimatedSprite.get_animation() == "RectRight"):
		$AnimatedSprite.play("RectLeft")
	elif($AnimatedSprite.get_animation() == "HeartLeft"):
		$AnimatedSprite.play("HeartRight")
	elif($AnimatedSprite.get_animation() == "HeartRight"):
		$AnimatedSprite.play("HeartLeft")
		
func _on_Sprite_collectCircle(object):
	if self.type == object.type:
		object.queue_free()

func _on_Sprite_collectRect(object):
	if self.type == object.type:
		object.queue_free()

func _on_Sprite_collectHeart(object):
	if self.type == object.type:
		object.queue_free()
