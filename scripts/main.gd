extends Node2D

func _ready() -> void:
	Game.player1 = $Player1
	Game.player2 = $Player2

func _process(_delta: float) -> void:
	if $Player1.health <= 0 or $Player2.health <= 0:
		var winner
		if $Player1.health <= 0:
			winner = 2
		else:
			winner = 1
		Game.finished = true
		$CanvasLayer/UI.visible = false
		$CanvasLayer/WinScreen.visible = true
		$CanvasLayer/WinScreen/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Label.text = "Player "+str(winner)+" wins!"

func _unhandled_key_input(_event: InputEvent) -> void:
	$CanvasLayer/Controls.visible = false
