extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("PLAYER"):
			position = Vector2(500, 500) #So the signal for screen exited queued free
			if collider.mana < 10:
				collider.mana += 1
			get_node("/root/LevelUI").update_currency(collider.mana)
