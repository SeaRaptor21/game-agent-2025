extends Node2D

@export var data = 1
var wind_scene = preload("res://scenes/wind.tscn")
var started = false

func _ready() -> void:
	rotation = 0.0 if data==1 else PI

func _process(_delta: float) -> void:
	if $DistanceFinder.is_colliding() and not started:
		var distance = floor(to_local($DistanceFinder.get_collision_point()).length()/16)
		for d in range(distance):
			var node = wind_scene.instantiate()
			node.position = Vector2(16,0)*d
			$Wind.add_child(node)
		started = true

func _on_timer_timeout() -> void:
	var node = wind_scene.instantiate()
	#node.position = Vector2(16,0)*data
	$Wind.add_child(node)
