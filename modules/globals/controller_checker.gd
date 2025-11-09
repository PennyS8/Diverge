## This global/autoload checks every input what the device type was, and on change, emits
## a signal that can be connected to other elements, such as ui or gameplay related ones.
## 
## The ideal scenario is that some UI element is connected to `input_device_changed` and
## hides the mouse and changes button prompts when it's emitted.
extends Node

enum InputType {
	MKEYS,
	GAMEPAD
}

var mouse_mode_dict : Dictionary[bool, Input.MouseMode] = {
	false: Input.MOUSE_MODE_CONFINED,
	true: Input.MOUSE_MODE_CONFINED_HIDDEN
}

var input_type_dict : Dictionary[bool, InputType] = {
	false: InputType.MKEYS,
	true: InputType.GAMEPAD
}

signal input_device_changed(device : InputType)

var using_gamepad : bool :
	get:
		return using_gamepad
	set(new_state):
		if new_state != using_gamepad:
			using_gamepad = new_state
			input_device_changed.emit(input_type_dict[new_state])
			if !get_tree().paused:
				Input.mouse_mode = mouse_mode_dict[new_state]
			print_debug("Using Gamepad Changed!: " + str(using_gamepad))

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent):
	if event is InputEventKey:
		using_gamepad = false
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.5:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			using_gamepad = true
	elif event is InputEventJoypadButton:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		using_gamepad = true
