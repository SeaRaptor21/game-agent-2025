class_name Wind extends Area2D

const SPEED = 64.0 # Pixels/second, should be a multiple of the tile size
@onready var direction = $"../..".data # Get the direction from parent fan
var colliding = false # Flag to delete after a timer

func _physics_process(delta: float) -> void:
	# Parent node is already rotated, so direcion doesn't need to be factored in here
	position.x += SPEED*delta

func _on_body_entered(_body: Node2D) -> void:
	colliding = true
	# Create a timer for the movement of one tile's width
	await get_tree().create_timer(Game.TILE_SIZE/SPEED, true).timeout
	if not colliding:
		return # Don't delete if we're no longer colliding, i.e. when coming out of the fan
	queue_free()

func _on_body_exited(_body: Node2D) -> void:
	colliding = false # We're no longer colliding with a body
