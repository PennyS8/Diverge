extends Area2D

@export var opened := false
@export var key_num := 0
@export var puzzle_sfx : AudioStreamPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _ready():
	KeyChain.key.connect(_toggle_door)
	
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
	sprite.frame = 1
	KeyChain.puzzle_chime($AudioStreamPlayer)

func _close_door():
	opened = false
	sprite.frame = 0
	
