extends Button

export(String) var path


func _on_MenuButton_pressed() -> void:
	get_tree().change_scene_to(load(path))
