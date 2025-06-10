extends Control

@onready var winner_label = $WinnerLabel

func set_winner(player_id: int):
	winner_label.text = "Player %d wins!" % player_id
