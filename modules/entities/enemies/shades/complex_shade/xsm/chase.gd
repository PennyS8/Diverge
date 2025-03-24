@tool
extends State

@onready var soft_collision = %SoftCollision

@export var state_speed : float

@onready var movement_target_pos : Vector2
@onready var nav_agent : NavigationAgent2D = %NavAgent

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	# if we're allowed to go towards player. else, wait around them until able
	if !EnemyManager.request_engagement(target):
		# we call ..._node_force() so that we don't run on_update
		# The function takes in a node rather than a name since 
		# the name finding thing runs at the start of each frame
		change_state_node_force($"../WaitNearPlayer")
	else:
		target.movement_speed = state_speed

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	target.set_movement_target(target.follow_object)

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
	# When we leave "Chasing" we let other enemies know its okay to engage
	EnemyManager.release_engagement(target)


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
