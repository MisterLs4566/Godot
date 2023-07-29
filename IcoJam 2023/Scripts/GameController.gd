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
	emit_signal("startTimer")
	circle = preload("res://Prefabs/Circle.tscn")
	rect = preload("res://Prefabs/Rect.tscn")
	heart = preload("res://Prefabs/Heart.tscn")
	
func _process(delta):
	pass

"""Timer und Spielpausierung"""

func _on_Node2D_startTimer():
	if level == 0:
		emit_signal("gameStart")
		level += 1
	$Timer.wait_time = 3.0
	$Timer.start()
	
"""Wenn 3 Sekunden Timer abgelaufen"""
func _on_Timer_timeout():
	emit_signal("resume")


"""Wenn das Spiel startet"""
func _on_Node2D_gameStart():
	print("test")
	circleObject = circle.instance()
	circleObject.position = Vector2(0, 0)
	circleObject.connect("gameStart", self, "_on_Node2D_gameStart")
	circleObject.connect("resume", self, "_on_Node2D_resume")
