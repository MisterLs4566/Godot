extends Area2D

var player
var healthLabel
var grav
var state = 0
var type
var coll
var game

signal collectCircle(object)
signal collectRect(object)
signal collectHeart(object)
signal damage

func _ready():
	player = get_node("/root/Node2D/Player")
	healthLabel = get_node("/root/Node2D/HealthLabel")
	if is_in_group("Circle"):
		type = "Circle"
	elif is_in_group("Rect"):
		type = "Rect"
	elif is_in_group("Heart"):
		type = "Heart"
	elif is_in_group("Trophy"):
		type = "Trophy"
	elif is_in_group("Trap"):
		type = "trap"
	game = get_node("/root/Node2D")
	game.connect("gameStart", self, "_on_Node2D_gameStart")
	game.connect("resume", self, "_on_Node2D_resume")
	grav = game.gravity
	if type != "Trophy" and (type != "Trap"):
		connect(str("collect", type), player, str("_on_Sprite_collect", type))
	connect("damage", healthLabel, "_on_Player_damage")

func checkY():
	if position.y >= 1110 and (type!="trap"):
		emit_signal("damage")
		queue_free()
		if(type == "Trophy"):
			get_tree().reload_current_scene()
func collision():
	if type == "Trap":
		return
	if $AnimatedSprite.get_animation() != str(type, "Destroy"):
		coll = get_overlapping_bodies()
		for c in coll:
			if c.is_in_group("Player"):
				if type == "Trophy":
					grav = 0
					$AnimatedSprite.play("TrophyDestroy")
				else:
					emit_signal(str("collect", type), self)

func _process(delta):
	position.y += grav * state * delta
	collision()
	checkY()
func _on_Node2D_resume():
	state = 1

func _on_Node2D_gameStart():
	state = 1


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "TrophyDestroy":
		game.level += 1
		get_tree().change_scene_to(load(str("res://Scenes/Level", game.level, ".tscn")))
	elif $AnimatedSprite.get_animation() == str(type, "Destroy"):
		queue_free()
