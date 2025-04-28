@tool
extends State

@onready var soft_collision = %SoftCollision
@export var state_speed : float

@onready var movement_target_pos : Vector2

const MIN_SEEK_DISTANCE := 24.0
const MAX_SEEK_DISTANCE := 32.0

## Will move towards target if greater than this distance
var pursue_distance_max := randf_range(56.0, 64.0)
## Will move away from target if less than this distance
var pursue_distance_min := randf_range(36.0, 48.0)

@export var strafe_factor := 0.25

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	## if we're allowed to go towards player. else, wait around them until able
	#if !EnemyManager.request_engagement(target):
		## we call ..._node_force() so that we don't run on_update
		## The function takes in a node rather than a name since 
		## the name finding thing runs at the start of each frame
		#change_state_node_force($"../WaitNearPlayer")
	#else:
	target.follow_object = get_tree().get_first_node_in_group("player")
	target.movement_speed = state_speed

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	var target_position = target.follow_object.global_position
	var displacement = target_position - target.global_position
	
	var distance = displacement.length()
	var target_angle = displacement.angle()
	
	# Needs to be cleared at the start to reset data from last frame
	target.ai_steering.clear()
	# Avoid walls
	target.ai_steering.apply_collision_avoidance(target, 8.0)
	
	# Move towards target if too far away
	if distance > pursue_distance_max:
		change_state_node_force($Pursue, target_angle)
	# Move away from target if too close
	elif distance < pursue_distance_min:
		change_state_node_force($Backpedal, target_angle)
	# Within normal range, so just strafe
	else:
		change_state_node_force($Encircle, target_angle)

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	# Used to determine what we should push away from
	var neighbors = soft_collision.get_overlapping_bodies()
	neighbors.erase(target)
	
	# Use a bias if seeking so we prefer our current direction
	target.ai_steering.apply_seek(target.velocity.angle(), 0.1)
	# Move away from nearby entities
	target.ai_steering.apply_separation(target.global_position, neighbors, 24.0, 0.5)


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass
	# When we leave "Chasing" we let other enemies know its okay to engage
	#EnemyManager.release_engagement(target)


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
