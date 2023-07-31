extends Node2D

signal gameStart
signal startTimer
signal resume
var level = 0

var circle
var SObject
var rect
var heart
var spawnCooldown
var spawnTimer = false
var stopped = true
var spawnX
var spawnO
var type
var spawnPositions
var gravity = 900

func _ready():
	circle = load("res://Prefabs/Circle.tscn")
	rect = preload("res://Prefabs/Rect.tscn")
	heart = preload("res://Prefabs/Heart.tscn")
	connect("gameStart", self, "_on_Node2D_gameStart")
	connect("startTimer", self, "_on_Node2D_startTimer")
	connect("startTimer", get_node("/root/Node2D/CountdownLabel"), "_on_Node2D_startTimer")
	emit_signal("startTimer")
	spawnPositions = [-1600, -1440, -1280, -1120, -960, -800, -640, -480, -320, -160, 0, 
	160, 320, 480, 640, 800, 960, 1120, 1280, 1440, 1600]
	level = int($LevelLabel.text[$LevelLabel.text.length()-1])
	gravity = gravity + level * 10
func _process(delta):
	if spawnTimer == false:
		if stopped == false:
			spawnTimer = true
			$Timer.wait_time = 2
			$Timer.start()

"""Timer und Spielpausierung"""

func _on_Node2D_startTimer():
	$Timer.wait_time = 3.0
	$Timer.start()
	
"""Wenn 3 Sekunden Timer abgelaufen"""
func _on_Timer_timeout():
	if level == 1:
		$CanvasLayer.visible = true
	elif level == 2:
		$CanvasLayer.visible = true
		$CanvasLayer.visible = true
	if stopped == true:
		stopped = false
		emit_signal("resume")
	if spawnTimer == true:
		spawnTimer = false
		emit_signal("resume")

"""Wenn das Spiel startet"""
func _on_Node2D_gameStart():
	emit_signal("resume")

"""veraltetes Spawn System"""
func spawn(position):
	spawnX = randi() % 21
	spawnX = spawnPositions[spawnX]
	spawnO = randi() % 3 + 1
	if spawnO == 1:
		type = circle
	elif spawnO == 2:
		type = rect
	elif spawnO == 3:
		type = heart
	SObject = type.instance()
	$GameBorder.add_child(SObject)
	position.x = spawnX
	SObject.position = position
