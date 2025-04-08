extends Control

func _ready() -> void:
	$FadeToBlack.play("fade_in", -1, 10)

func _on_human_pressed() -> void:
	$FadeToBlack.play("fade_out")
	await $FadeToBlack.animation_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_agent_pressed() -> void:
	$FadeToBlack.play("fade_out")
	await $FadeToBlack.animation_finished
	var tree = get_tree()
	tree.change_scene_to_file("res://scenes/main.tscn")
	tree.root.child_entered_tree.connect(
		func (scene) -> void: scene.set_as_agent(),
		CONNECT_ONE_SHOT
	)

func _on_quit_pressed() -> void:
	get_tree().quit()

func fade() -> void:
	$FadeToBlack.play("fade_in")
