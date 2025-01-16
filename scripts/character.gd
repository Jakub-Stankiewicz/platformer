extends CharacterBody2D

@onready var label = $"../Label"

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var jump_count = 1
const MAX_JUMP_COUNT = 2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	label.text = str(jump_count)
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or jump_count < MAX_JUMP_COUNT):
		jump_count += 1
		velocity.y = JUMP_VELOCITY

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		
	if is_on_floor():
		jump_count = 1

	move_and_slide()
