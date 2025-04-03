extends Control

func _process(_delta: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/P1Health.value = Game.player1.health
	$MarginContainer/VBoxContainer/HBoxContainer/P2Health.value = Game.player2.health
