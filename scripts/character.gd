extends CharacterBody2D

@onready var projectile_scene = preload("res://scenes/projectile.tscn")
@onready var game = get_node("/root/GameController")  # dopasuj ścieżkę jeśli masz inaczej

@export var player_id: int = 1 

var speed = 300.0
var jump_velocity = -600.0
var max_jump_count = 2

var jump_count = 0
var direction = 0.0

var player_devices = GameController.player_devices

var previous_jump_pressed = false
var previous_shoot_pressed = false

var max_health: int = 5
var current_health: int = 5

@onready var animated_sprite = $Sprite2D

func get_player_id():
	return player_id

func _ready():
	print("Player ready with id: ", player_id)
	update_health_label()
	update_ammo_label()
	add_to_group("players")

	animated_sprite.play("idle_p" + str(player_id))
	
	game.connect("lives_updated", Callable(self, "_on_lives_updated"))
	#if $Hitbox:
		#$Hitbox.connect("body_entered", Callable(self, "_on_body_entered"))

	#if game:
		#game.connect("lives_updated", Callable(self, "_on_lives_updated"))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	var input_direction := 0.0

	# --- KLWIATURA STEROWANIE ---
	if player_id == 1:
		if Input.is_action_pressed("p1_right"):
			input_direction += 1.0
		if Input.is_action_pressed("p1_left"):
			input_direction -= 1.0
		if Input.is_action_just_pressed("p1_jump") and jump_count < max_jump_count:
			jump()
		if Input.is_action_just_pressed("p1_shoot"):
			shoot(sign(direction) if direction != 0 else 1.0)

	elif player_id == 2:
		if Input.is_action_pressed("p2_right"):
			input_direction += 1.0
		if Input.is_action_pressed("p2_left"):
			input_direction -= 1.0
		if Input.is_action_just_pressed("p2_jump") and jump_count < max_jump_count:
			jump()
		if Input.is_action_just_pressed("p2_shoot"):
			shoot(sign(direction) if direction != 0 else 1.0)

	# --- PAD (jeśli używasz) ---
	for device_id in player_devices.keys():
		if player_devices[device_id] != player_id:
			continue

		var axis_x = Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X)
		if abs(axis_x) > 0.1:
			input_direction = axis_x

		var jump_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_B)
		if jump_pressed and not previous_jump_pressed:
			if jump_count < max_jump_count:
				jump()
		previous_jump_pressed = jump_pressed

		var shoot_pressed = Input.is_joy_button_pressed(device_id, JOY_BUTTON_A)
		if shoot_pressed and not previous_shoot_pressed:
			shoot(sign(input_direction) if input_direction != 0 else 1.0)
		previous_shoot_pressed = shoot_pressed

	# --- RUCH ---
	if abs(input_direction) > 0.1:
		direction = sign(input_direction)
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# --- ANIMACJE ---
	if direction == 1.0:
		animated_sprite.flip_h = false
		animated_sprite.play("walk_p" + str(player_id))
	elif direction == -1.0:
		animated_sprite.flip_h = true
		animated_sprite.play("walk_p" + str(player_id))
	else:
		animated_sprite.play("idle_p" + str(player_id))

	move_and_slide()


func shoot(shooting_direction):
	if GameController.current_ammo <= 0:
		print("Brak amunicji!")
		return

	GameController.current_ammo -= 1
	update_ammo_label()

	var projectile = projectile_scene.instantiate()
	if shooting_direction == -1.0:
		projectile.direction = Vector2.LEFT
	else:
		projectile.direction = Vector2.RIGHT
	projectile.global_position = global_position + (projectile.direction * 60)

	get_tree().current_scene.add_child(projectile)  # <- dodaj do drzewa NAJPIERW

	projectile.shooter = self  # <- dopiero wtedy ustaw "shooter"



func jump():
	jump_count += 1
	velocity.y = jump_velocity


func update_ammo_label():
	var label_name = "ammoP%d" % player_id
	var label_path = "Arena/" + label_name
	var label = get_tree().root.get_node(label_path)
	label.text = "%d / %d" % [GameController.current_ammo, GameController.max_ammo]


func update_health_label():
	var label_name = "player_%d_lives" % player_id
	var label_path = "Arena/" + label_name
	var label = get_tree().root.get_node(label_path)
	label.text = "%d / %d" % [current_health, max_health]


func _on_body_entered(body):
	if body.is_in_group("projectiles"):
		if body.owner != self:
			if game:
				game.update_lives(player_id, -1)
			body.queue_free()


func _on_lives_updated(updated_player_id: int, lives: int):
	if updated_player_id == player_id:
		current_health = lives
		update_health_label()
		if current_health <= 0:
			die()
			

func die():
	print("Gracz %d zginął!" % player_id)
	queue_free()
