extends Area2D

@export var opened := false
@export var key_num := 0
@export var puzzle_sfx : AudioStreamPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var glint_group : CanvasGroup = $Glint
@onready var glint_sprite : Sprite2D = $Glint/Sprite2D

@export var locked_sprite : Texture2D
@export var unlocked_sprite : Texture2D

var interactable : bool = false
@onready var player = get_tree().get_first_node_in_group("player")
@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String

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
	glint_sprite.texture = unlocked_sprite
	KeyChain.puzzle_chime($AudioStreamPlayer)

func _close_door():
	opened = false
	sprite.texture = unlocked_sprite
	glint_sprite.texture = unlocked_sprite

func _unhandled_input(_event: InputEvent) -> void:
	if !interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		
		if !key_in:
			if KeyChain.num_smallkeys > 0:
				key_in = true
				KeyChain.num_smallkeys -= 1
				KeyChain.key.emit(key_num, true)
		
		#if key_in:
				var fade_time := 0.5
				var fade_screen = %TransitionOverlay
				player.dir = Vector2.ZERO
				LevelManager.change_level(next_level_path, entrance_name)
				
				player.lock_camera = true
				var tween = get_tree().create_tween()
				tween.set_parallel(false)
				tween.tween_property(fade_screen, "color:a", 1, fade_time)
	
		get_viewport().set_input_as_handled()

func _on_area_2d_body_entered(body: Node2D) -> void:
	interactable = true
	$Glint.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	interactable = false
	$Glint.hide()
