extends Area2D

var player
var grav = 900
var state = 0
var type
var coll

signal collectCircle(object)
signal collectRect(object)
signal collectHeart(object)

func _ready():
	player = get_node("/root/Node2D/Player")
	if is_in_group("Circle"):
		type = "Circle"
	elif is_in_group("Rect"):
		type = "Rect"
	elif is_in_group("Heart"):
		type = "Heart"
	connect(str("collect", type), player, str("_on_Sprite_collect", type))
func _process(delta):
	position.y += grav * state * delta
	coll = get_overlapping_bodies()
	for c in coll:
		if c.is_in_group("Player"):
			emit_signal(str("collect", type), self)

func _on_Node2D_resume():
	state = 1

func _on_Node2D_gameStart():
	state = 1
