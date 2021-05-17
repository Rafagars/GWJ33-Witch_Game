extends RigidBody2D

export var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = Vector2(self.position.x, self.position.y)
	$Move_tween.interpolate_property(self, "position", position, target, 4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += 120 * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
