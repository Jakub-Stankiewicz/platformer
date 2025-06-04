extends CharacterBody2D

@onready var projectile_scene = preload("res://scenes/projectile.tscn")

#@export var player_id: int

var speed = 300.0
var jump_velocity = -600.0
var max_jump_count = 2

var jump_count = 0
var direction = 1.0



func shoot(shooting_direction):
	var projectile = projectile_scene.instantiate()
	
	if shooting_direction == -1.0:
		projectile.direction = Vector2.LEFT
	else:
		projectile.direction = Vector2.RIGHT

	projectile.global_position = global_position + (projectile.direction * 60)#(offset)
	get_tree().current_scene.add_child(projectile)

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

#HEALTH
var max_health: int = 5
var current_health: int = 3

@export var player_id: int = 1  # ustaw w edytorze 1 lub 2

func add_health(amount: int):
	current_health = min(current_health + amount, max_health)
	print("HP:", current_health)
	update_health_label()
	
func update_health_label():
	var label_name = "player_%d_lives" % player_id
	var label_path = "Arena/" + label_name
	var label = get_tree().root.get_node(label_path)
	label.text = "%d / %d" % [current_health, max_health]

func _ready():
	update_health_label()
