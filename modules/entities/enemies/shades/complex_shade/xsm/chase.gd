@tool
extends StateSound

@onready var soft_collision = %SoftCollision

@export var state_speed : float

@onready var movement_target_pos : Vector2
@onready var nav_agent : NavigationAgent2D = %NavAgent

var is_engaging : bool = false
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
# Code related to nav_agent & tilemap integration are inspired by: 
# "Shifty the Dev"
# https://blog.shiftythedev.com/posts/GodotTilemapNavigation/
#

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
	# if we lose player,
	if !target.follow_object:
		change_state("Patrol_Idle")
	
	# if we're allowed to go towards player. else, wait around them until able
	if engage():
		movement_target_pos = target.follow_object.global_position
		target.set_movement_target(movement_target_pos)
		
		if nav_agent.is_navigation_finished():
			change_state("Attack")
	else:
		change_state("WaitNearPlayer")


## Returns true if we have permission from enemy manager to engage [br]
## If our is_engaging is already set to true, then we're already clear.
func engage():
	if is_engaging:
		return true
	is_engaging = EnemyManager.request_engagement(target)
	return is_engaging

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
