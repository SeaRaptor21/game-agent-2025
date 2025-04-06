extends Node2D

@export var data = 1
var wind_scene = preload("res://scenes/wind.tscn")

func _on_timer_timeout() -> void:
	var node = wind_scene.instantiate()
	#node.position = Vector2(16,0)*data
	$Wind.add_child(node)
