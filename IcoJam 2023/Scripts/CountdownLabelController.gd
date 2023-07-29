extends Label

var state = 4
func _ready():
	text = ""


func _on_Node2D_startTimer():
	state -= 1
	text = str(state)
	$Timer.wait_time = 1
	$Timer.start()

func _on_Timer_timeout():
	if(state > 1):
		state -= 1
		text = str(state)
		$Timer.wait_time = 1
		$Timer.start()
	else:
		text = ""
