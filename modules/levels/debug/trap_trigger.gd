extends Area2D

var triggered

@export var key_id := 0
func _on_body_entered(body : CharacterBody2D):
	if !triggered:
		if body.is_in_group("player"):
			triggered = true
			KeyChain.key.emit(key_id, false)
			$AudioStreamPlayer.play()
			$"../TrapEnemies".visible = true
