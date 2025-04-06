extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(0.5, true).timeout
		body.win()
