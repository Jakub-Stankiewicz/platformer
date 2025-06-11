extends Node2D

@onready var winner_label = $CenterContainer/VBoxContainer/WinnerLabel

func _ready():
	set_winner(GameState.winner_id)

func set_winner(player_id: int):
	winner_label.text = "Gracz %d wygrywa!" % player_id


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
