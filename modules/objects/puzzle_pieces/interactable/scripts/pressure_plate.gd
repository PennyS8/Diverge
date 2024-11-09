extends Area2D

@export var key_id := 0
@export var enabled := false
@export var stays_down := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enabled:
		$Sprite2D.frame = 1
	
	KeyChain.key.connect(_key_toggle)

func pop_up():
	enabled = false
	$Sprite2D.frame = 0

func push_down():
	enabled = true
	$Sprite2D.frame = 1
	KeyChain.key.emit(key_id, enabled)

func _on_body_entered(body: Node2D) -> void:
	if !enabled:
		push_down()

func _on_body_exited(body: Node2D) -> void:
	if enabled and !stays_down:
		if !get_overlapping_bodies():
			pop_up()
			KeyChain.key.emit(key_id, enabled)
	
func _key_toggle(id, state):
	if id == key_id and !state:
		pop_up()
	
