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


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
