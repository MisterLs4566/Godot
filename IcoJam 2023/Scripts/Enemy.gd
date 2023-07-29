extends Area2D

var player
var grav = 900
var state = 0
var type
var coll

signal collectCircle
signal collectRect
signal collectHeart

func _ready():
	"""INDEX des Spielers muss stimmen"""
	player = get_node("../Player")
	if is_in_group("Circle"):
		type = "Circle"
	elif is_in_group("Rect"):
		type = "Rect"
	elif is_in_group("Heart"):
		type = "Heart"
	print(str("collect", type))
	connect(str("collect", type), player, str("_on_Sprite_collect", type))
func _process(delta):
	#move_and_slide(Vector2.DOWN * grav * state)
	position.y += grav * state * delta
	coll = get_overlapping_bodies()
	for c in coll:
		if c.is_in_group("Player"):
			emit_signal(str("collect", type))
			queue_free()

func _on_Node2D_resume():
	state = 1

func _on_Node2D_gameStart():
	state = 1
