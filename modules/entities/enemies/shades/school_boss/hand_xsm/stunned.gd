@tool
extends StateSound

@onready var hurt_box = %HurtBox
var hurt_box_collision

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	add_timer("StunnedTimer", 5.0)
	## NOTE: Gets first child as we don't have more than the collision shape. Will
	## need to change if more children are added.
	# Gets the CollisionShape associated with the HurtBox
	hurt_box_collision = hurt_box.get_child(0)
	
	hurt_box_collision.disabled = false

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass

# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	hurt_box_collision.disabled = true

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass

# Called when any other Timer times out
func _on_timeout(_name) -> void:
	change_state("Idle")
