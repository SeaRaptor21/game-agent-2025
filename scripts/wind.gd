class_name Wind extends Area2D

const SPEED = 64.0 # Pixels/second, should be a multiple of the tile size
@onready var direction = $"../..".data # Get the direction from parent fan
var colliding = false # Flag to delete after a timer
var first_time = true # Use a longer timer for the first collision b/c we're in the fan block

func _physics_process(delta: float) -> void:
	# Parent node is already rotated, so direcion doesn't need to be factored in here
	position.x += SPEED*delta

func _on_body_entered(_body: Node2D) -> void:
	colliding = true
	# Create a timer for a bit less than the movement of one tile's width
	# Longer timer for the first time because we don't want to delete the wind
	# before it makes it out of the fan
	await get_tree().create_timer(Game.TILE_SIZE/SPEED/(1.0 if first_time else 1.5), true).timeout
	if not colliding:
		first_time = false # We've collided once now
		return # Don't delete if we're no longer colliding, i.e. when coming out of the fan
	queue_free()

func _on_body_exited(_body: Node2D) -> void:
	colliding = false # We're no longer colliding with a body
