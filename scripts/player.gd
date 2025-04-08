class_name Player extends CharacterBody2D

const TILE_SIZE = 16
const SPEED_SCALE = 1.0
var speed = 10.0
var fall_speed = 10.0  # Should be integer multiple of speed

var done = false

func _ready() -> void:
	$MoveTimer.start(1.0/speed)

func _physics_process(_delta: float) -> void:
	if done:
		return
	move_and_slide()
	#speed = SPEED_SCALE*round(position.y/100)+10

func _on_move_timer_timeout() -> void:
	if done:
		return
	position = round(position/TILE_SIZE)*TILE_SIZE
	if not $DeathTrigger.get_overlapping_bodies().is_empty():
		die()
	if not is_on_floor():
		velocity.y = fall_speed*TILE_SIZE
	var direction := get_direction()
	if direction:
		$AnimatedSprite2D.flip_h = direction>0
	var winds = $WindChecker.get_overlapping_areas()
	if not winds.is_empty():
		direction = winds[0].direction
	velocity.x = direction*speed*TILE_SIZE

func get_direction() -> float:
	return Input.get_axis("left", "right")

func die() -> void:
	$"..".lose()
	done = true

func win() -> void:
	$"..".win()
	done = true
