extends "res://characters/Enemy.gd"

export var health = 2


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
			Globals.number_of_knights -= 1
			drop_loot()
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
