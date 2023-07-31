extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", get_node("/root/Node2D"), "_on_Timer_timeout")
	connect("timeout", get_node("/root/Node2D/CountdownLabel"), "_on_Timer_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
