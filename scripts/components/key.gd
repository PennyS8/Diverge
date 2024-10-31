extends Area2D

@export var key_id := 0


func _on_body_entered(body):
	if body.is_in_group("player"):
		KeyChain.key.emit(key_id, true)
		queue_free()
