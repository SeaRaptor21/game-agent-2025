extends Node2D

var agent_script = preload("res://scripts/agent.gd")

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
	$CanvasLayer2/FadeToBlack.play("fade_in")

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

func set_as_agent() -> void:
	$Player.set_script(agent_script)

func win() -> void:
	$CanvasLayer2/EndScreens/WinScreen.visible = true

func lose() -> void:
	$CanvasLayer2/EndScreens/LoseScreen.visible = true

func _on_return_pressed() -> void:
	$CanvasLayer2/FadeToBlack.play("fade_out")
	await $CanvasLayer2/FadeToBlack.animation_finished
	var tree = get_tree()
	tree.change_scene_to_file("res://scenes/title.tscn")
	tree.root.child_entered_tree.connect(
		func (scene) -> void: scene.fade(),
		CONNECT_ONE_SHOT
	)
