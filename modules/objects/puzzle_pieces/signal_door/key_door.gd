extends Area2D

@export var opened := false
@export var key_num := 0
@export var puzzle_sfx : AudioStreamPlayer
@onready var sprite : Sprite2D = $Sprite2D

@export var locked_sprite : Texture2D
@export var unlocked_sprite : Texture2D

var key_in := false

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
	sprite.texture = unlocked_sprite
	KeyChain.puzzle_chime($AudioStreamPlayer)

func _close_door():
	opened = false
	sprite.texture = unlocked_sprite

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !key_in:
		if KeyChain.num_smallkeys > 0:
			key_in = true
			KeyChain.num_smallkeys -= 1
			KeyChain.key.emit(key_num, true)
