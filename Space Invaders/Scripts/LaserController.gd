extends KinematicBody2D

var speed = 700
var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity * speed)


func _on_Player_shoot():
	#get_parent().print_tree()
	get_parent().get_parent().move_child(self, 0)
	visible = true
	velocity.y = -1
