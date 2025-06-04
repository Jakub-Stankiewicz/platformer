extends Control

var using_mouse := true

const MOUSE_TIMEOUT := 0.1 


func _ready():
	for button in $VBoxContainer.get_children():
		if button is Button:
			button.focus_mode = Control.FOCUS_ALL
			button.mouse_entered.connect(func(): button.grab_focus())

	$VBoxContainer/play.grab_focus()
	# Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# set_process_input(true)

## BUTTONS
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/arena.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")
