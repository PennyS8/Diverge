@tool
extends StateSound

@export var ground_speed := 250.0
@export var acceleration := 6.0
@export var friction := 10
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.velocity == Vector2.ZERO:
		change_state("Idle")
		
	target.velocity = lerp(target.velocity, target.dir * ground_speed, acceleration * _delta)

# when another state (such as attack or dash) transitions us out of this,
# set our velocity to zero so we don't get weird sliding
# if we have like, an ice level or slippery path, we prob wanna change this
func _on_exit(_args):
	target.velocity = Vector2.ZERO
