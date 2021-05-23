extends Area2D

var dir = Vector2.ZERO
onready var player = get_parent().get_node("Player")
export var health = 2
var heart_scene = preload("res://obj/Heart/Heart.tscn")
var mana_scene = preload("res://obj/ManaOrb/ManaOrb.tscn")
onready var hurt = $Hurt
var turned = false #If turned into animal or not
var spawn_point = Vector2.ZERO #Point from where the enemy spawn
var counter = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if turned == false:
		dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
		self.position += dir * delta * 60
		if Vector2(player.position.x - self.position.x, player.position.y - self.position.y).length() < 30:
			$Slash.play()
			$AnimatedSprite.play("Attack")
			$Attack.disabled = false
		else:
			$AnimatedSprite.play("Walk")
			$Attack.disabled = true
	else:
		dir = Vector2(spawn_point.x - self.position.x, spawn_point.y - self.position.y).normalized()
		self.position += dir * delta * 60
	if health < 1:
		$AnimatedSprite.visible = false
		turned = true
		$Animal.visible = true
		$CollisionShape2D.disabled = true
		if spawn_point.x == -10 :
			$Animal.flip_h = true
		$Animal.play()
		if counter > 0:
			$Fly.play()
			if get_node("/root/LevelUI/Level1").random_fifty_fifty() == 0:
				#To avoid "infinites" orb spawning
				var mana = mana_scene.instance()
				mana.position = self.position
				get_parent().add_child(mana)
			else:
				var heart = heart_scene.instance()
				heart.position = self.position
				get_parent().add_child(heart)
			Globals.number_of_knights -= 1
			counter -= 1
		
	if $Attack/RayCast2D.is_colliding():
		var collider = $Attack/RayCast2D.get_collider()
		if collider.is_in_group("PLAYER") and collider.hit == false:
			collider.hit = true
			collider.health -= 1
			collider.healthCooldownTimer.start(collider.healthCooldown)
			get_node("/root/LevelUI").update_hearts(4, collider.health)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Animal_animation_finished():
	$Animal.play("Flying")
