extends Area2D

@export var ammo_amount: int = 3  # ile ammo daje ten pickup

func _on_body_entered(body):
	if body.has_method("add_ammo"):
		body.add_ammo(ammo_amount)
		queue_free()  # znika po zebraniu
