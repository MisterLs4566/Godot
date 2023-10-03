extends "res://Scripts/EnemyController.gd"
var playerVec = Vector2.ZERO
var selfVec = Vector2.ZERO
func move():
	if velocity == Vector2.ZERO:
		playerVec = Vector2(player.position.x, player.position.y)
		selfVec = Vector2(self.position.x, self.position.y)
		self.velocity = (playerVec - selfVec).normalized()
	move_and_slide(self.velocity * self.speed)
