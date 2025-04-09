class_name Title extends Control

func _ready() -> void:
	# Fade in, mostly for transitions from main scene
	$FadeToBlack.play("fade_in")

func fade_out() -> void:
	# Fade out to black. Must be awaited
	$FadeToBlack.play("fade_out")
	await $FadeToBlack.animation_finished

func _on_human_pressed() -> void:
	# Fade out and wait, then show corresponding splash screen and fade in again
	await fade_out()
	$Human.visible = true
	$FadeToBlack.play("fade_in")

func _on_play_human_pressed() -> void:
	# Fade out and wait, then change to main scene.
	# Main scene will fade in again on _ready.
	await fade_out()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_agent_pressed() -> void:
	# Fade out and wait, then show corresponding splash screen and fade in again
	await fade_out()
	$Agent.visible = true
	$FadeToBlack.play("fade_in")

func _on_play_agent_pressed() -> void:
	await fade_out() # Fade out and wait
	var tree = get_tree()
	tree.change_scene_to_file("res://scenes/main.tscn") # Change to main scene
	tree.root.child_entered_tree.connect(
		# All autoload nodes have been added already, so the only node added
		# now will be the Main node.
		func (scene) -> void: scene.set_as_agent(), # Change the script so it's agent controlled
		CONNECT_ONE_SHOT # Only call this function once
	)

func _on_train_agent_screen_pressed() -> void:
	# Fade out and wait, then show corresponding splash screen and fade in again
	await fade_out()
	$Train.visible = true
	$FadeToBlack.play("fade_in")

func _on_train_agent_pressed() -> void:
	# Get value from spinbox
	var episodes = $Train/MarginContainer/VBoxContainer/HBoxContainer2/Episodes.value
	Game.agent.learn(episodes) # Train the agent
	Game.total_episodes += episodes # Change the total episodes, shown on training splash screen

func _on_reset_agent_pressed() -> void:
	Game.agent.reset() # Set the Q-Table to all zeroes
	Game.total_episodes = 0 # Go back to zero episodes trained

func _on_help_pressed() -> void:
	# Fade out and wait, then show corresponding splash screen and fade in again
	await fade_out()
	$Help.visible = true
	$FadeToBlack.play("fade_in")

func _on_docs_pressed() -> void:
	# Fade out and wait, then show corresponding splash screen and fade in again
	await fade_out()
	$Docs.visible = true
	$FadeToBlack.play("fade_in")

func _on_return_pressed() -> void:
	# Fade out and wait
	await fade_out()
	# Hide all of the splash screens
	$Help.visible = false
	$Docs.visible = false
	$Human.visible = false
	$Agent.visible = false
	$Train.visible = false
	$FadeToBlack.play("fade_in") # Fade in

func _on_sans_serif_toggled(toggled_on: bool) -> void:
	# Allow the user to toggle a sans serif font for the docs, rather than
	# the standard pixel font. This can make the docs easier to read, and since
	# the docs are somewhat lengthy, that's definitely useful.
	var label = $Docs/MarginContainer/VBoxContainer/ScrollContainer/RichTextLabel
	if toggled_on:
		# Give it a sans serif font and reset the font size
		# Empty system font = font default = sans serif
		label.add_theme_font_override("normal_font", SystemFont.new())
		label.remove_theme_font_size_override("normal_font_size")
	else:
		# Remove the font override and give it a larger font
		# The font used for this project is smaller in general than a normal font
		label.remove_theme_font_override("normal_font")
		label.add_theme_font_size_override("normal_font_size", 24)

func _on_quit_pressed() -> void:
	get_tree().quit() # Quit the game

func _process(_delta: float) -> void:
	# Update the splash screen for training to show the total episodes trained
	$Train/MarginContainer/VBoxContainer/Label.text = str(Game.total_episodes)+" Episodes trained so far"
