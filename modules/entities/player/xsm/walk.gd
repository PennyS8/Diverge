@tool
extends StateSound

@export var ground_speed := 250.0
@export var acceleration := 6.0
@export var friction := 10

var idle_dir := Vector2.DOWN
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

#var directions : Dictionary = {Vector2(0,1): "Down",
								#Vector2(0,-1): "Up",
								#Vector2(1,0): "Right",
								#Vector2(1, -1): "Right",
								#Vector2(1, 1): "Right",
								#Vector2(-1,0): "Left",
								#Vector2(-1,-1): "Left",
								#Vector2(-1, 1): "Left",
								#Vector2(0, 0): "Down"}

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass
	
# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.dir == Vector2.ZERO:
		change_state("Idle", idle_dir)
	
	target.velocity = lerp(target.velocity, target.dir * ground_speed, acceleration * _delta)

	var xdir = target.dir.snapped(Vector2.ONE).x
	var ydir = target.dir.snapped(Vector2.ONE).y
	
	if xdir == 1:
		play_blend("walk_right", 0.0)
		idle_dir = Vector2.RIGHT
	elif xdir == -1:
		play_blend("walk_left", 0.0)
		idle_dir = Vector2.LEFT
	elif xdir == 0:
		if ydir == 1:
			play_blend("walk_down", 0.0)
			idle_dir = Vector2.DOWN
		elif ydir == -1:
			play_blend("walk_up", 0.0)
			idle_dir = Vector2.UP
		
# when another state (such as attack or dash) transitions us out of this,
# set our velocity to zero so we don't get weird sliding
# if we have like, an ice level or slippery path, we prob wanna change this
func _on_exit(_args):
	target.velocity = Vector2.ZERO
	stop()
