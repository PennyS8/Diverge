extends Area2D

@export var key_id := 0
@export var enabled := false
@export var stays_down := false

@export var frame1 : Texture2D
@export var frame2 : Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enabled:
		$Sprite2D.texture = frame2
	
	KeyChain.key.connect(_key_toggle)

func pop_up():
	enabled = false
	$Sprite2D.texture = frame1

func push_down():
	enabled = true
	$Sprite2D.texture = frame2
	KeyChain.key.emit(key_id, enabled)

func _on_body_entered(_body: Node2D) -> void:
	if !enabled:
		push_down()
		
		if _body.is_in_group("block"):
			_body.puzzle_completed = true

func _on_body_exited(_body: Node2D) -> void:
	if enabled and !stays_down:
		if !get_overlapping_bodies():
			pop_up()
			KeyChain.key.emit(key_id, enabled)
			
		if _body.is_in_group("block"):
			_body.puzzle_completed = false
	
func _key_toggle(id, state):
	if id == key_id and !state:
		pop_up()
