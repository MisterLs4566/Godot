extends Label

var score

func _on_Player_coin():
	score = int(text)
	text = str(score + 1)
