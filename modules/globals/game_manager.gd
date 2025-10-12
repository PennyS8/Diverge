extends Node

var _inventory_node : Control
var inventory_node : Control :
	get:
		return _inventory_node
	set(val):
		_inventory_node = val
		inventory = val.inventory

var inventory
signal last_ramen_picked_up()
var overlay : Control

@export var hitfreeze_scale := 0.05
@export var hitfreeze_time := 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Lock mouse and also ensure that we can unlock mouse even during game pauses
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	pass
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("attack_melee"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			return
	pass

func hitlag():
	Engine.time_scale = hitfreeze_scale
	await get_tree().create_timer(hitfreeze_time * hitfreeze_scale).timeout
	Engine.time_scale = 1
