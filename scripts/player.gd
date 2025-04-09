class_name Player extends CharacterBody2D

var speed = 10.0 # The player's basic speed for left and right
var fall_speed = 10.0  # Should be integer multiple of speed, mostly for testing

# Flag will be set when a spike or the goal is hit, stopping movement
var done = false

func _ready() -> void:
	# Match the timer to the velocity to give smooth movement
	$MoveTimer.start(1.0/speed)

func _physics_process(_delta: float) -> void:
	if done:
		return # Don't move if we've hit a spike or the goal
	move_and_slide() # Otherwise just move with current velocity

func _on_move_timer_timeout() -> void:
	if done:
		return # Don't move if we've hit a spike or the goal
	# Round our position to the nearest tile
	position = round(position/Game.TILE_SIZE)*Game.TILE_SIZE
	if not $DeathTrigger.get_overlapping_bodies().is_empty():
		# Trigger death if we have a body inside of the death trigger.
		# The death trigger has a mask set up to only collide with spikes.
		die()
	if not is_on_floor():
		# Fall at a constant speed
		velocity.y = fall_speed*Game.TILE_SIZE
	var direction := get_direction() # Keyboard input for human, QL agent for agent
	if direction:
		# Point our spirte the correct direction
		$AnimatedSprite2D.flip_h = direction>0
	var winds = $WindChecker.get_overlapping_areas() # Check for wind
	if not winds.is_empty():
		# If there is wind, move in the same direction it is.
		# This happens regardless of the type of player.
		direction = winds[0].direction
	# Move at a constant speed in the selected direction
	velocity.x = direction*speed*Game.TILE_SIZE

func get_direction() -> float:
	# Keyboard input for human, will be overridden in the Agent class
	return Input.get_axis("left", "right")

func die() -> void:
	$"..".lose() # Call lose on Main
	done = true # Stop moving

func win() -> void:
	$"..".win() # Call win on Main
	done = true # Stop moving
