extends Node

signal lives_updated(player_id: int, lives: int)

var max_lives := 10
var players: Dictionary

var player_devices = {}

# func _ready():
# 	OS.window_fullscreen = true
# 	# optionally set window size if needed:
# 	# OS.window_size = Vector2(1920, 1080)


func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion: #and event.pressed:
		if event.device not in player_devices:
			var new_player_id = player_devices.size() + 1
			player_devices[event.device] = new_player_id
			# print("Assigned controller ", event.device, " to player ", new_player_id)
	

func new_game(number_of_players):
	for i in range(number_of_players):
		add_player(i)



func add_player(player_id: int):
	players[player_id] = max_lives
	emit_signal("lives_updated", player_id, max_lives)



func update_lives(player_id: int, amount: int):
	if players.has(player_id):
		players[player_id] += amount
		emit_signal("lives_updated", player_id, players[player_id])

		if players[player_id] <= 0:
			player_died(player_id)


func player_died(player_id: int):
	print("Player %d is out!" % player_id)
