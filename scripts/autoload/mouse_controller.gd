extends Node

# This script controlls the mouse cursor. The cursor disappears when an arrow or a gamepad key is pressed
# and reappears when the mouse is moved

var using_mouse := true

const MOUSE_TIMEOUT := 0.1 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	# _set_buttons_mouse_enabled(true)
		

func _input(event):
	if event is InputEventMouseMotion:
		if not using_mouse:
			_enable_mouse()
	elif _is_keyboard_or_gamepad_input(event):
		if using_mouse:
			_disable_mouse()


func _is_keyboard_or_gamepad_input(event: InputEvent) -> bool:
	return (
		event is InputEventKey and event.pressed and not event.echo
		or event is InputEventJoypadButton and event.pressed
		or event is InputEventJoypadMotion
	)


func _disable_mouse():
	using_mouse = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# change_input_mode("not mouse")
	print("mouse disabled")



func _enable_mouse():
	using_mouse = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# change_input_mode("mouse")
	print("mouse enabled")


func change_input_mode(mode):
	# var mouse_filter = Control.MOUSE_FILTER_STOP if enable else Control.MOUSE_FILTER_IGNORE
	# for button in get_tree().get_nodes_in_group("menu_buttons"):
	# 	button.mouse_filter = mouse_filter
	var mouse_filter = Control.MOUSE_FILTER_STOP if mode == "mouse" else Control.MOUSE_FILTER_IGNORE
	for button in get_tree().get_nodes_in_group("menu_buttons"):
		button.mouse_filter = mouse_filter
		if mode != "mouse":
			button.release_focus()  # Clear focus if switching to keyboard/gamepad
	if mode != "mouse":
		get_tree().set_current_focus(null)  # Clear global focus
