extends Node2D

signal gameStart
signal startTimer
signal resume
var level = 0

var circle
var circleObject
var rect
var heart

func _ready():
	VisualServer.set_default_clear_color(Color("#2697f0"))
	circle = load("res://Prefabs/Circle.tscn")
	rect = preload("res://Prefabs/Rect.tscn")
	heart = preload("res://Prefabs/Heart.tscn")
	emit_signal("startTimer")
	
func _process(delta):
	pass

"""Timer und Spielpausierung"""

func _on_Node2D_startTimer():
	$Timer.wait_time = 3.0
	$Timer.start()
	
"""Wenn 3 Sekunden Timer abgelaufen"""
func _on_Timer_timeout():
	if(level == 0):
		level += 1
		emit_signal("gameStart")
	else:
		emit_signal("resume")


"""Wenn das Spiel startet"""
func _on_Node2D_gameStart():
	circleObject = circle.instance()
	$GameBorder.add_child(circleObject)
	circleObject.position = Vector2(0, -900)
	connect("gameStart", circleObject, "_on_Node2D_gameStart")
	connect("resume", circleObject, "_on_Node2D_resume")
	emit_signal("resume")
