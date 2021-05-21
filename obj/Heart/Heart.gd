extends Area2D


func _ready():
	$Timer.set_wait_time(5)
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("PLAYER"):
			position = Vector2(500, 500) #So the signal for screen exited queued free
			if collider.health < 4:
				collider.health += 1
			get_node("/root/LevelUI").update_hearts(4, collider.health)
			queue_free()


func _on_Timer_timeout():
	$Sprite.visible = false
	$Dissappear.visible = true
	$Dissappear.play("dissappear")


func _on_Sprite_animation_finished():
	queue_free()
	
