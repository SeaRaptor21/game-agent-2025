class_name Fan extends Node2D

@export var data = 1 # Special data parameter for direction: -1 == left, 1 == right
var wind_scene = preload("res://scenes/wind.tscn")
var started = false # Spawn in all wind nodes as soon as possible, then set this flag

func _ready() -> void:
	# Set the direction to match data
	rotation = 0.0 if data==1 else PI

func _process(_delta: float) -> void:
	# Spawn wind nodes every tile up to the closest next tile
	# I tried doing this in _ready, but it seemed that the RayCast2D
	# wasn't fully initialized at that point, so we wait for that
	if $DistanceFinder.is_colliding() and not started:
		var distance = floor(to_local($DistanceFinder.get_collision_point()).length()/16)
		for d in range(distance):
			# Spawn in a wind node at a certain distance
			var node = wind_scene.instantiate()
			node.position = Vector2(Game.TILE_SIZE,0)*d
			$Wind.add_child(node)
		started = true # Set the flag so these only spawn in once

func _on_timer_timeout() -> void:
	# Spawn in a wind node at the current position,
	# Runs every 1/4 second
	var node = wind_scene.instantiate()
	$Wind.add_child(node)
