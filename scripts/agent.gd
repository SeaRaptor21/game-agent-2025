class_name Agent extends Player

func get_direction() -> float:
	# Rather than use keyboard input for moving around, we simply
	# query the agent for any movement.
	return Game.agent.next_state(get_state())%Game.WIDTH-get_state()%Game.WIDTH

func get_state() -> int:
	# Round our position to a grid and turn into a number for
	# the state
	return round(position.x/Game.TILE_SIZE)+Game.WIDTH*round(position.y/Game.TILE_SIZE)
