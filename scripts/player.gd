extends CharacterBody2D

const TILE_SIZE = 16
const SPEED_SCALE = 1.0
var speed = 10
var fall_speed = 20  # Should be integer multiple of speed

func _ready() -> void:
	$MoveTimer.start(1.0/speed)

func _physics_process(_delta: float) -> void:
	move_and_slide()
	#speed = SPEED_SCALE*round(position.y/100)+10

func _on_move_timer_timeout() -> void:
	position = round(position/TILE_SIZE)*TILE_SIZE
	if not is_on_floor():
		velocity.y = fall_speed*TILE_SIZE
	var direction := Input.get_axis("left", "right")
	if direction:
		$AnimatedSprite2D.flip_h = direction == 1
	velocity.x = direction*speed*TILE_SIZE

func _on_death_trigger_body_entered(_body: Node2D) -> void:
	queue_free()
