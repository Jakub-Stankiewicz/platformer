extends Node2D  # lub odpowiedni typ

@onready var game_over_scene = preload("res://scenes/menus/GameOver.tscn")

func _ready():
	var game_controller = get_node("/root/GameController")
	game_controller.connect("game_over", Callable(self, "_on_game_over"))

func _on_game_over(winner_id):
	var game_over = game_over_scene.instantiate()
	add_child(game_over)
	game_over.set_winner(winner_id)
