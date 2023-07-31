extends RigidBody2D

var speed = 100
var velocity = Vector2.ZERO
var oldPos
var type
var changePossible = true
var cooldown = 0.5
var oScaleX
var oScaleY
signal coin
var game

func _ready():
	game = get_node("/root/Node2D")
	oldPos = position
	type = "Circle"
	oScaleX = $AnimatedSprite.get_scale().x
	oScaleY = $AnimatedSprite.get_scale().y
	if($AnimatedSprite.animation == "Circle"):
		type = "Circle"
		VisualServer.set_default_clear_color(Color("#5b6ee1"))	
	elif($AnimatedSprite.animation == "Rect"):
		type = "Rect"
		VisualServer.set_default_clear_color(Color("#df7126"))
	elif($AnimatedSprite.animation == "Heart"):
		type = "Heart"
		VisualServer.set_default_clear_color(Color("#8f974a"))
	
func cooldown():
	changePossible = false
	$AnimatedSprite.scale.x = $AnimatedSprite.get_scale().x/1.25
	$AnimatedSprite.scale.y  = $AnimatedSprite.get_scale().y/1.25
	$Timer.wait_time = cooldown
	$Timer.start()
	
func input():
	
	if (Input.is_action_just_pressed("ui_end")):
		get_tree().change_scene_to(load("res://Scenes/MenuScene.tscn"))
	
	"""Animation"""
	
	if (Input.is_action_pressed("ui_accept")):
		if(game.stopped == true):
			return
		if changePossible == false:
			return
		if($AnimatedSprite.animation == "Circle"):
			$AnimatedSprite.play("Rect")
			type = "Rect"
			VisualServer.set_default_clear_color(Color("#df7126"))
			cooldown()
		elif($AnimatedSprite.animation == "Rect"):
			$AnimatedSprite.play("Heart")
			type = "Heart"
			VisualServer.set_default_clear_color(Color("#8f974a"))
			cooldown()
		elif($AnimatedSprite.animation == "Heart"):
			$AnimatedSprite.play("Circle")
			type = "Circle"
			VisualServer.set_default_clear_color(Color("#5b6ee1"))
			cooldown()
			
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

func _process(delta):
	input()
		
func _on_Sprite_collectCircle(object):
	if self.type == object.type:
		object.grav = 0
		object.get_child(0).play(str(object.type, "Destroy"))
		emit_signal("coin")

func _on_Sprite_collectRect(object):
	if self.type == object.type:
		object.grav = 0
		object.get_child(0).play(str(object.type, "Destroy"))
		emit_signal("coin")

func _on_Sprite_collectHeart(object):
	if self.type == object.type:
		object.grav = 0
		object.get_child(0).play(str(type, "Destroy"))
		emit_signal("coin")


func _on_Timer_timeout():
	if changePossible == false:
		changePossible = true
		$AnimatedSprite.scale.x = oScaleX
		$AnimatedSprite.scale.y = oScaleY
