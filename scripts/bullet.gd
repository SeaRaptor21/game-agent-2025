extends Area2D

const SPEED = 400.0
const DAMAGE = 10

@export var player = 1

func _process(delta: float) -> void:
	position += SPEED*delta*Vector2(1,0).rotated(rotation)

func _on_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		queue_free()
	elif body is Player:
		if body.player != player:
			queue_free()
			body.health -= DAMAGE
