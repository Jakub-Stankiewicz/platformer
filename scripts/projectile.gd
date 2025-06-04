extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta

func _ready():
	# Connect signal for collision
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node):
	# You can filter by node type if needed
	if body.is_in_group("players"):
		GameController.update_lives(body.player_id, -1)
	queue_free()
