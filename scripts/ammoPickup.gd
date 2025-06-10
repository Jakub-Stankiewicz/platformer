extends Area2D

@export var ammo_amount: int = 3  # ile ammo daje ten pickup

func _on_body_entered(body):
	if body.is_in_group("players"):
		GameController.update_ammo(3)
		queue_free()  # znika po zebraniu
