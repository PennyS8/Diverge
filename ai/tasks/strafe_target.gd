@tool
extends BTAction
## Circles the target. [br]
## Returns [code]SUCCESS[/code].

### Minimum distance to start circling.
#@export var range_min: float = 36.0
#
### Maximum distance to circle - transition to closing in after this distance
#@export var range_max: float = 56.0

## Blackboard variable that holds current target (should be a Node2D instance).
@export var target_var: StringName = &"target"

@export var circle_speed: float = 55

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "StrafeTarget  target: %s" % [
		LimboUtility.decorate_var(target_var),
		#range_min,
		#range_max
	]

func _tick(delta):
	var target := blackboard.get_var(target_var) as Node2D
	if not is_instance_valid(target):
		return FAILURE
	
	if agent is CharacterBody2D:

		var target_pos_relative : Vector2 = target.global_position - agent.global_position
		var angle = target_pos_relative.angle()
		
		agent.ai_steering.clear()
		
		#TODO: change 0.25 out for a strafe_factor variable
		agent.ai_steering.apply_seek(agent.velocity.angle(), 0.1)
		agent.ai_steering.apply_strafe(angle, 0.3)
		agent.ai_steering.apply_seek(angle, 0.1)
		
		#TODO: apply ai_steering forces in task after this rather than in the same state
		# Get the direction we want to move
		var normal = agent.ai_steering.get_desired_normal()
		var desired_velocity = normal * circle_speed
		
		agent.move(desired_velocity)
		
		return RUNNING
