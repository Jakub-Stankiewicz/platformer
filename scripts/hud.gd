extends CanvasLayer

@onready var p1_label = $Player1LivesLabel
@onready var p2_label = $Player2LivesLabel
 

func _ready():
	# GameController.lives_updated.connect(update_lives)
	pass

func update_lives(player_id: int, lives: int):
	match player_id:
		0:
			p1_label.text = "Lives: %d" % lives
		1:
			p2_label.text = "Lives: %d" % lives
