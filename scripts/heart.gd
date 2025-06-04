extends Area2D

@export var heal_amount: int = 1

func _ready():
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("add_health"):
		body.add_health(heal_amount)
		queue_free()  # usunięcie serca po zebraniu
