@tool
extends StateSound

@onready var status_holder = $"../../../StatusHolder"
@onready var yarn_raycast = $"../../../YarnRayCast2D"

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	if yarn_raycast.is_colliding():
		var collided_body = yarn_raycast.get_collider() # Get first body collided with
		# Apply status effects to the player and the collided body
		collided_body.get_parent().add_status("tethered")
		status_holder.add_status("tethered")
	
	change_state("CanAttack")
	change_state("Idle")

func _on_update(delta: float) -> void:
	pass

func _on_exit(_args) -> void:
	pass
