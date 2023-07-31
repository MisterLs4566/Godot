extends Label
var health
func _ready():
	health = int(text)

func _on_Player_damage():
	if health > 2:
		health = int(text)
		text = str(health-1)
	else:
		get_tree().reload_current_scene()
