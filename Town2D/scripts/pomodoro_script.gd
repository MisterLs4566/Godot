extends Node2D
var minutes = 60
var reached_minutes = 0
var reached_hours = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color("000000", 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$Counter.text = str(int($Timer.time_left))
	if($Timer.is_stopped() != true):
		$Counter.text = str(reached_hours) + " : " + str(reached_minutes) + " : " +str(int(60-$Timer.time_left))
	else:
		$Counter.text = "0 : 0 : 0"
	

func _on_button_pressed():
	if($Button.text == "Start"):
		$Button.text = "Stop"
		$Timer.start()
		$TownButton.disabled = true
	else:
		$Button.text = "Start"
		$Timer.stop()
		$TownButton.disabled = false


func _on_timer_timeout():
	reached_minutes += 1
	if(minutes-1 == reached_minutes):
		reached_hours += 1
		reached_minutes = 0
	
	


func _on_town_button_pressed():
	get_tree().change_scene_to_file("res://scenes/scene_2d.tscn")
