extends Node2D

signal gameStart
signal startTimer
var level = 0

func _ready():
	VisualServer.set_default_clear_color(Color("#2697f0"))
	emit_signal("startTimer")

func _process(delta):
	pass

"""Wenn der Timer fertig ist"""

func _on_Node2D_resume():
	pass # Replace with function body.

"""Timer und Spielpausierung"""

func _on_Node2D_startTimer():
	$Timer.wait_time = 3.0
	$Timer.start()
	
"""Wenn 3 Sekunden Timer abgelaufen"""
func _on_Timer_timeout():
	emit_signal("resume")
