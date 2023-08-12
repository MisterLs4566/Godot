extends TileMap
"""nodes"""

var player
var collisionTile

func _ready():
	player = get_node("/root/Node2D/Player")
func collision():
	collisionTile = get_cellv(player.position)
	#print(collisionTile)
	
func _process(delta):
	collision()
