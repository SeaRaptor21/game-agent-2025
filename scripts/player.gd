class_name Player extends CharacterBody2D

const TILE_SIZE = 16
const SPEED_SCALE = 1.0
var speed = 10.0
var fall_speed = 10.0  # Should be integer multiple of speed

func _ready() -> void:
	$MoveTimer.start(1.0/speed)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	#speed = SPEED_SCALE*round(position.y/100)+10

func _on_move_timer_timeout() -> void:
	position = round(position/TILE_SIZE)*TILE_SIZE
	if not $DeathTrigger.get_overlapping_bodies().is_empty():
		die()
	if not is_on_floor():
		velocity.y = fall_speed*TILE_SIZE
	var direction := Input.get_axis("left", "right")
	var winds = $WindChecker.get_overlapping_areas()
	if not winds.is_empty():
		direction = winds[0].direction
	if direction:
		$AnimatedSprite2D.flip_h = direction == 1
	velocity.x = direction*speed*TILE_SIZE

func die():
	pass

func win():
	pass
