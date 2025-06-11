extends Area2D  # <-- To jest kluczowe!

var shooter = null

@export var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))  # poprawne podłączenie sygnału

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node):
	if body.is_in_group("players"):
		if body == shooter:
			return  # Nie zadaj obrażeń sobie
		GameController.update_lives(body.player_id, -1)
		queue_free()
