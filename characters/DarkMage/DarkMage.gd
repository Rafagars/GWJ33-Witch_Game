extends "res://characters/Enemy.gd"

var beam_scene = preload("res://characters/DarkMage/beam/MageBeam.tscn")
export var health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootTimer.set_wait_time(1.5)
	$ShootTimer.start()


func _process(delta):
	if turned == false:
		dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
		if self.position.x < 75 or self.position.x > 400:
			self.position += dir * delta * 60
	else:
		dir = Vector2(spawn_point.x - self.position.x, spawn_point.y - self.position.y).normalized()
		self.position += dir * delta * 60
	if health < 1:
		$AnimatedSprite.visible = false
		turned = true
		$Animal.visible = true
		$CollisionShape2D.disabled = true
		if self.position.x > 400:
			$Animal.flip_h = true
		$Animal.play()
		if counter > 0:
			Globals.number_of_mages -= 1
			drop_loot()
			counter -= 1

func spawn_beams():
	var beam = beam_scene.instance()
	beam.position = self.position
	beam.dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
	
	get_parent().add_child(beam)
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ShootTimer_timeout():
	if health > 0:
		spawn_beams()
		$Shoot.play()
