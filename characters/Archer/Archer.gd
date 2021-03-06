extends Area2D

var dir = Vector2.ZERO
var arrow_scene = preload("res://characters/Archer/arrow/Arrow.tscn")
var mana_scene = preload("res://obj/ManaOrb/ManaOrb.tscn")
var heart_scene = preload("res://obj/Heart/Heart.tscn")
onready var player = get_parent().get_node("Player")
export var health = 1
onready var hurt = $Hurt
var turned = false #If turned into animal or not
var spawn_point = Vector2.ZERO #Point from where the enemy spawn
var counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var target = Vector2(self.position.x, self.position.y)
	$Move_tween.interpolate_property(self, "position", position, target, 4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Draw.play()
	$AnimatedSprite.play("Draw")
	$Shoot.set_wait_time(3)
	$Shoot.start()

func _process(delta):
	if turned == false:
		dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
		if self.position.x < 50 or self.position.x > 425:
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
		$Animal.play("Fox")
		if counter > 0:
			$Fox.play()
			Globals.number_of_archers -= 1
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

		
	
func spawn_arrows():
	var arrow = arrow_scene.instance()
	arrow.dir = Vector2(player.position.x , player.position.y - self.position.y).normalized()
	if self.position.x > 400:
		arrow.get_node("Sprite").flip_h = true
		arrow.dir = Vector2(-player.position.x , player.position.y - self.position.y).normalized()
	arrow.position = self.position
	
	
	get_parent().add_child(arrow)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Shoot_timeout():
	if health > 0: #This avoid the enemy for keep firing after defeated
		$AnimatedSprite.play("Fire")
		$Fire.play()
		spawn_arrows()
