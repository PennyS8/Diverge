@tool
extends StateSound

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

@onready var agro_region : Area2D = %AgroRegion
@onready var soft_collision = %SoftCollision

@onready var movement_target_pos : Vector2
@export var nav_agent : NavigationAgent2D
@export var state_speed : float

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	target.movement_speed = state_speed

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var possible_follow_targets = agro_region.get_overlapping_bodies()
	for follow_target in possible_follow_targets:
		if follow_target.is_in_group("player"):
			target.follow_object = follow_target
			change_state("Surprised")
	
	if nav_agent.is_navigation_finished():
		return

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
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
