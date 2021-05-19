extends Area2D

var dir = Vector2.ZERO
var arrow_scene = preload("res://characters/Archer/arrow/Arrow.tscn")
onready var player = get_parent().get_node("Player")
export var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = Vector2(self.position.x, self.position.y)
	$Move_tween.interpolate_property(self, "position", position, target, 4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$AnimatedSprite.play("Draw")
	$Shoot.set_wait_time(2)
	$Shoot.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
	if self.position.x < 25 or self.position.x > 450:
		self.position += dir * delta * 60
	else:
		pass
	
	if health < 1:
		Globals.i -= 1
		queue_free()
	
func spawn_arrows():
	var arrow = arrow_scene.instance()
	if self.position.x > 400:
		arrow.get_node("Sprite").flip_h = true
	arrow.position = self.position
	arrow.dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
	
	get_parent().add_child(arrow)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Shoot_timeout():
	if health > 0:
		$AnimatedSprite.play("Fire")
		spawn_arrows()
