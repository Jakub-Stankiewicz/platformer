extends Node

signal lives_updated(player_id: int, lives: int)

@export var max_ammo: int = 10
var current_ammo: int = 5

@export var max_lives: int = 5

var players := {} # Stores player_id -> lives
var player_devices := {} # Stores device_id -> player_id

func _ready():
	print("GameController ready, starting new game with 2 players")
	new_game(2)

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event.device not in player_devices:
			var new_player_id = player_devices.size() + 1
			player_devices[event.device] = new_player_id
			add_player(new_player_id)


func new_game(number_of_players):
	players.clear()
	player_devices.clear()
	for i in range(1, number_of_players + 1): # player IDs start from 1
		add_player(i)


func add_player(player_id: int):
	players[player_id] = max_lives
	emit_signal("lives_updated", player_id, max_lives)
	print("Player %d added with %d lives." % [player_id, max_lives])


func update_lives(player_id: int, amount: int):
	if players.has(player_id):
		players[player_id] += amount
		players[player_id] = clamp(players[player_id], 0, max_lives)
		print("Updated lives for player %d: %d" % [player_id, players[player_id]])
		emit_signal("lives_updated", player_id, players[player_id])

	if players[player_id] <= 0:
		player_died(player_id)
	else:
		print("Player id not found:", player_id)



func update_ammo(amount: int):
	current_ammo += amount
	current_ammo = clamp(current_ammo, 0, max_ammo)
	print("Ammo updated: %d / %d" % [current_ammo, max_ammo])


func player_died(player_id: int):
	print("Player %d is out!" % player_id)
