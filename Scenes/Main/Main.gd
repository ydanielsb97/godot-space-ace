extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		GameManager.load_level_scene()

func _on_start_button_button_up() -> void:
	GameManager.load_level_scene()
