class_name Main extends Node2D

var start_position = Vector2(80, 32) # The tile that the player starts on, in global coordinates
var agent_script = preload("res://scripts/agent.gd")

@onready var map = $TileMapLayer

# This dict allows us to spawn in specialized nodes at any
# TileMap tile, letting us give them more specialized behavior.
# The data parameter lets us pass some information to the new
# node, which below is only used for direction, but could also
# be used for flags or more complex measures.
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
	$CanvasLayer2/FadeToBlack.play("fade_in") # Fade in from black

func make_special_tiles() -> void:
	for cell in map.get_used_cells(): # Find all used cells
		var data = map.get_cell_tile_data(cell)
		# Get the custom data on the tile and find it in the dictionary above
		var special = special_tiles.get(data.get_custom_data("special"))
		if special: # Ignore if not present in the dict
			var node = special["scene"].instantiate() # Create the node
			# Move it to the position of the tile
			node.position = map.to_global(map.map_to_local(cell))
			if "data" in special: # The tiles might not need a data parameter
				node.data = special["data"] # Set the data
			$Special.add_child(node)

func set_as_agent() -> void:
	# Change the player node to use the agent script.
	# This new script inherits from Player, so it's physics
	# and movement are identical, but it's movement is
	# now controlled by a Q-Learning agent.
	$Player.set_script(agent_script)

func win() -> void:
	# Show win screen
	$CanvasLayer2/EndScreens/WinScreen.visible = true

func lose() -> void:
	# Show lose screen
	$CanvasLayer2/EndScreens/LoseScreen.visible = true

func _on_replay_pressed() -> void:
	# Hide the win/lose screens
	$CanvasLayer2/EndScreens/WinScreen.visible = false
	$CanvasLayer2/EndScreens/LoseScreen.visible = false
	# Fade out and wait
	$CanvasLayer2/FadeToBlack.play("fade_out")
	await $CanvasLayer2/FadeToBlack.animation_finished
	# Reset the player, but don't enable movement yet
	$Player.position = start_position
	# Fade in and wait
	$CanvasLayer2/FadeToBlack.play("fade_in")
	await $CanvasLayer2/FadeToBlack.animation_finished
	$Player.done = false # Now enable movement
	$Player._on_move_timer_timeout() # Reset any motion or velocity

func _on_return_pressed() -> void:
	# Fade out and wait
	$CanvasLayer2/FadeToBlack.play("fade_out")
	await $CanvasLayer2/FadeToBlack.animation_finished
	# Go back to title screen
	get_tree().change_scene_to_file("res://scenes/title.tscn")
