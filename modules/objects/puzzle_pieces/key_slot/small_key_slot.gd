extends Area2D

@export var sprite1 : Texture2D
@export var sprite2 : Texture2D

@export var key_in := false

@export var key_id := 0
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !key_in:
		if KeyChain.num_smallkeys > 0:
			key_in = true
			KeyChain.num_smallkeys -= 1
			$Sprite2D.texture = sprite2
			KeyChain.key.emit(key_id, true)
