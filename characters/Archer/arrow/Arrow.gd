extends Area2D

var dir = Vector2(1,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position += dir * delta * 150
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("PLAYER") and collider.hit == false:
			position = Vector2(500, 500)
			collider.hit = true
			collider.health -= 1
			collider.healthCooldownTimer.start(collider.healthCooldown)
			get_node("/root/LevelUI").update_hearts(4, collider.health)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
