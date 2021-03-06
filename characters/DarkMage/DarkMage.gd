extends Area2D

var dir = Vector2.ZERO
var beam_scene = preload("res://characters/DarkMage/beam/MageBeam.tscn")
var mana_scene = preload("res://obj/ManaOrb/ManaOrb.tscn")
var heart_scene = preload("res://obj/Heart/Heart.tscn")
onready var player = get_parent().get_node("Player")
export var health = 3
onready var hurt = $Hurt
var turned = false #If turned into animal or not
var spawn_point = Vector2.ZERO #Point from where the enemy spawn
var counter = 1


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
			if get_node("/root/LevelUI/Level1").random_fifty_fifty() == 0:
				#To avoid "infinites" orb spawning
				var mana = mana_scene.instance()
				mana.position = self.position
				get_parent().add_child(mana)
			else:
				var heart = heart_scene.instance()
				heart.position = self.position
				get_parent().add_child(heart)
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
