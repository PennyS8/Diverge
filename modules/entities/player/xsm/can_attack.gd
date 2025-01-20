@tool
extends State

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var num_tethered_nodes = $"/root/StatusEffectsManager".num_tethered_nodes()
	
	if Input.is_action_just_pressed("attack_melee"):
		change_state("AttackMelee")
	elif Input.is_action_just_pressed("lasso"):
		# Prevents the player from lassoing when 2 entities are already tethered
		if num_tethered_nodes < 2:
			change_state("Lasso")
	elif Input.is_action_just_pressed("throw"):
		# Ensure player has tethered EXACTLY 1 entity
		if num_tethered_nodes == 1:
			change_state("Throw")
