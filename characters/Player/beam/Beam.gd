extends Area2D

const BEAMSPEED = 300
var dir = Vector2(1, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * BEAMSPEED
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("Enemy"):
			position += Vector2(500,500)
			collider.health -= 1
			Globals.score += 10
			get_node("/root/LevelUI").update_score(Globals.score)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
