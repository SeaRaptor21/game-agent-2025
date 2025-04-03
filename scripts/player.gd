class_name Player extends CharacterBody2D

const ROTATION = 1.5
const SPEED = 600.0
const FRICTION = 400.0
const AIR_RESISTANCE = 200.0
const DAMPING = 0.8
const SHOOT_COOLDOWN = 0.2

@export var player = 1
@export var health = 100
var can_shoot = true
var shoot_timer = 0

var bullet_scene = preload("res://scenes/bullet.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if player == 1:
		rotate(ROTATION*delta)
	else:
		rotate(-ROTATION*delta)
	if not is_on_floor():
		velocity.y += gravity*delta
		velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION*delta)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = DAMPING*velocity.bounce(collision_info.get_normal())

func _process(delta: float) -> void:
	if not can_shoot:
		shoot_timer -= delta
		if shoot_timer <= 0:
			can_shoot = true
	if Input.is_action_pressed("p"+str(player)+"_shoot") and can_shoot and not Game.finished:
		var node = bullet_scene.instantiate()
		node.position = position
		if player == 1:
			node.rotation = rotation+ROTATION*0.1
		else:
			node.rotation = rotation-ROTATION*0.1
		node.player = player
		$Bullets.add_child(node)
		velocity = SPEED*Vector2(-1,0).rotated(rotation)
		shoot_timer = SHOOT_COOLDOWN
		can_shoot = false
