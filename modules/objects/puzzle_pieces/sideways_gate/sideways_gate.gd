extends StaticBody2D

@export var opened := false
@export var key_num := 0
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	KeyChain.key.connect(_toggle_door)
	if opened:
		visible = false
		set_collision_layer_value(5, false)

func _toggle_door(id : int, state : bool):
	# unlock signal does not match door
	if id != key_num:
		return
	
	if state:
		_open_door()
	else:
		_close_door()

func _open_door():
	opened = true
	visible = false
	KeyChain.puzzle_chime($AudioStreamPlayer)
	set_collision_layer_value(5, false)

func _close_door():
	opened = false
	visible = true
	set_collision_layer_value(5, true)
