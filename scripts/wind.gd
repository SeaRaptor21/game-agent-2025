class_name Wind extends Area2D

const SPEED = 64.0
@onready var direction = $"../..".data
var colliding = false

func _physics_process(delta: float) -> void:
	position.x += SPEED*direction*delta

func _on_body_entered(_body: Node2D) -> void:
	colliding = true
	await get_tree().create_timer(16.0/SPEED, true).timeout
	if not colliding:
		return
	queue_free()

func _on_body_exited(_body: Node2D) -> void:
	colliding = false
