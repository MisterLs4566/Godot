extends Area2D
var player

func _ready():
	player = get_parent().get_node("Player")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if self.get_meta("Room") == "Playground":
			player.level = 1
		player.set_room(self.get_meta("Room"))


func _on_body_exited(body):
	if body.is_in_group("Player"):
		player.set_room("")
	if self.get_meta("Room") == "Playground":
			player.level = 0
