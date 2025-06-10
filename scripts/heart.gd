extends Area2D

@export var heal_amount: int = 1

#func _ready():
	#connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	print("Collision with:", body)
	if body.is_in_group("players"):
		print("It's a player!")
		if body.has_method("get_player_id"):
			var id = body.get_player_id()
			print("Player id:", id)
			var game_controller = get_node("/root/GameController")
			game_controller.update_lives(id, heal_amount)  # dodajemy życie
			print("Healing player %d by %d" % [id, heal_amount])
			queue_free()
		else:
			print("Player missing get_player_id() method")
	else:
		print("Not a player group")



		
#func _on_body_entered(body):
	#if body.has_method("add_health"):
		#body.add_health(heal_amount)
		#queue_free()  # usunięcie serca po zebraniu
