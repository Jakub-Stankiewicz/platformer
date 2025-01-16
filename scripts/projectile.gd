extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var rotation_direction = 0  # the angle at which projectiles are shot

func _ready() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	print(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity += get_gravity() * delta
	
	if is_on_floor():
		queue_free()
		
	

	move_and_slide()
