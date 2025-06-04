extends Node

@onready var label1 = $CenterContainer/VBoxContainer/Player1
@onready var label2 = $CenterContainer/VBoxContainer/Player2
@onready var connect_label = $CenterContainer/VBoxContainer/"connect label"

var player_devices = GameController.player_devices  # e.g. {0: 1, 1: 2} means device 0 = Player 1, device 1 = Player 2

var any_key_pressed := false
var p1_connected = false
var p2_connected = false
var are_2_connected = false

var connected = Input.get_connected_joypads()

func _input(event):
    if event is InputEventJoypadButton and event.pressed:
        any_key_pressed = true

func _process(delta):
    update_gamepad_status_labels()

    if are_2_connected and any_key_pressed:
        get_tree().change_scene_to_file("res://scenes/arena.tscn")

func update_gamepad_status_labels():
    connected = Input.get_connected_joypads()  # Returns array of connected device IDs
    p1_connected = false
    p2_connected = false

    for device_id in connected:
        var pid = player_devices.get(device_id, null)
        if pid == 1:
            p1_connected = true
        elif pid == 2:
            p2_connected = true

    label1.text = "Player 1: Connected" if p1_connected else "Player 1: Not Connected"
    label2.text = "Player 2: Connected" if p2_connected else "Player 2: Not Connected"

    
    if p1_connected and p2_connected:
        connect_label.text = "press X to start"
        are_2_connected = true