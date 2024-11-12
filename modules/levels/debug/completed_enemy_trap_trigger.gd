extends Area2D

# PLACEHOLDER SCRIPT

var triggered
@export var key_id := 0
func _on_body_entered(body):
	if !triggered:
		if body.is_in_group("player"):
			triggered = true
			$"..".visible = false
			KeyChain.key.emit(key_id, true)
			$"../../../Key".process_mode = Node.PROCESS_MODE_INHERIT
			$"../../../Key".visible = true

			
		
