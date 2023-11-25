extends CharacterBody2D

var speed = 125
var fight = false
var direction = Vector2.ZERO
var fightAnimation = "FightDown"
var room = "Study Room"
var level = 0
var RoomLabel

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_animated_sprite_2d_animation_finished)
	RoomLabel = get_parent().get_node("CanvasLayer").get_node("Label")

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("ui_accept"):
		if level > 0:
			fight = true
			$AnimatedSprite2D.play(fightAnimation)
	
	velocity = direction * speed
	if fight == false:
		move_and_collide(velocity * delta)
	
	if fight == false:
		animateWalk()

func _process(delta):
	RoomLabel.text = room
	
func animateWalk():
	
	if velocity.y > 0:
		$AnimatedSprite2D.play("WalkDown")
		fightAnimation = "FightDown"
	elif velocity.y < 0:
		$AnimatedSprite2D.play("WalkUp")
		fightAnimation = "FightUp"
	elif velocity.x > 0:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.flip_h = false
		fightAnimation = "FightRight"
	elif velocity.x < 0:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.flip_h = true
		fightAnimation = "FightRight"
	else:
		$AnimatedSprite2D.play("Idle1")
		
func _on_animated_sprite_2d_animation_finished():
	if "Fight" in $AnimatedSprite2D.animation:
		fight = false
		
func set_room(r):
	room = r
