extends Node2D

@onready var map = $TileMapLayer
var special_tiles = {
	"goal": {
		"scene": preload("res://scenes/goal.tscn"),
	},
	"fan_left": {
		"scene": preload("res://scenes/fan.tscn"),
		"data": -1,
	},
	"fan_right": {
		"scene": preload("res://scenes/fan.tscn"),
		"data": 1,
	},
}

func _ready() -> void:
	make_special_tiles()

func make_special_tiles() -> void:
	for cell in map.get_used_cells():
		var data = map.get_cell_tile_data(cell)
		var special = special_tiles.get(data.get_custom_data("special"))
		if special:
			var node = special["scene"].instantiate()
			node.position = map.to_global(map.map_to_local(cell))
			if "data" in special:
				node.data = special["data"]
			$Special.add_child(node)
