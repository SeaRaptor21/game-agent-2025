class_name Goal extends Area2D

# Pretty much the most basic node possible,
# just a simple Area2D to detect the player

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Wait half a second then trigger a win
		await get_tree().create_timer(0.5, true).timeout
		body.win()
