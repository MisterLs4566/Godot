extends "res://Scripts/EnemyController.gd"
var playerVec = Vector2.ZERO
var selfVec = Vector2.ZERO
var deleteDistance

func _ready():
	self.speed *= 1.75
	self.maxPlayerDistance *= 1.25
	self.deleteDistance = 3000
	self.laserSpeed *= 0.75
func move():
	if self.velocity == Vector2.ZERO and position.distance_to(player.position) < maxPlayerDistance:
		playerVec = Vector2(player.position.x, player.position.y)
		selfVec = Vector2(self.position.x, self.position.y)
		self.velocity = (playerVec - selfVec).normalized()
	move_and_slide(self.velocity * self.speed)
	
	if position.distance_to(player.position) > self.deleteDistance:
		if self.velocity != Vector2.ZERO:
			queue_free()
