extends Control

func _on_play_human_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_train_agent_pressed() -> void:
	pass # Replace with function body.

func _on_play_function_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
