extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 10.0
const FRICTION = 10.0
const ELASTICITY = 0.8
const CAM_FOLLOW_SPEED = 300.0
const CAM_FOLLOW_DISTANCE = 100.0

func _process(delta: float) -> void:
	$Camera2D.position = $Camera2D.position.move_toward(position, delta*CAM_FOLLOW_SPEED)
	if (position-$Camera2D.position).length() > CAM_FOLLOW_DISTANCE:
		$Camera2D.position = ($Camera2D.position-position).normalized()*CAM_FOLLOW_DISTANCE+position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction*SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	var collision := move_and_collide(velocity*delta)
	if collision and collision.get_collider() is StaticBody2D: # TODO: check if bouncy
		velocity = velocity.bounce(collision.get_normal())*ELASTICITY
