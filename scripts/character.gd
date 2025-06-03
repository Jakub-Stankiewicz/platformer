extends CharacterBody2D

@onready var projectile_scene = preload("res://scenes/projectile.tscn")

var speed = 300.0
var jump_velocity = -600.0
var max_jump_count = 2

var jump_count = 0
var direction = 1.0



func shoot(shooting_direction):
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	
	if shooting_direction == -1.0:
		projectile.direction = (Vector2.LEFT)
	else:
		projectile.direction = (Vector2.RIGHT)

func jump():
	jump_count += 1
	velocity.y = jump_velocity



func _physics_process(delta: float) -> void:
	#label.text = str(jump_count)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if Input.get_axis("ui_left", "ui_right"):
		direction = 1.0 if Input.get_axis("ui_left", "ui_right") > 0 else -1.0   # checking becuase gmepad joys give values other than 1.0 and -1.0
		velocity.x = direction * speed
		print(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


	## SHOOTING
	if Input.is_action_just_pressed("shoot"):
		shoot(direction)
	
	## JUMPING
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count < max_jump_count):
		jump()
	

	## Resetting the jump count
	if is_on_floor():
		jump_count = 1

	move_and_slide()
