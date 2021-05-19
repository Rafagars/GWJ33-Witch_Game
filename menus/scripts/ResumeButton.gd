extends Button


func _on_Resume_pressed() -> void:
	get_tree().paused = false
	get_parent().get_parent().queue_free()
