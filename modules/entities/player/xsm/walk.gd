@tool
extends StateSound

@export var ground_speed := 60.0
@export var acceleration := 20.0
@export var friction := 10

var idle_dir := Vector2.DOWN

# the number of physics frames for walking against a wall to count as pushing
@export var push_frames := 20
var curr_push_frame := push_frames

# NOTE: Var is not being used
#var directions : Dictionary = {
	#Vector2( 0, 1): "Down",
	#Vector2( 0,-1): "Up",
	#Vector2( 1, 0): "Right",
	#Vector2( 1,-1): "Right",
	#Vector2( 1, 1): "Right",
	#Vector2(-1, 0): "Left",
	#Vector2(-1,-1): "Left",
	#Vector2(-1, 1): "Left",
	#Vector2( 0, 0): "Down"
#}

func _on_enter(_args):
	push_frames = 30

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta):
	if target.dir == Vector2.ZERO:
		change_state("Idle", idle_dir)

	# if juni has no hook, play no hook animations
	var no_hook = ""
	if target.hook_locked:
		no_hook = "no_spear/"
		
	target.velocity = lerp(target.velocity, target.dir * ground_speed, acceleration * _delta)
	
	var xdir = target.dir.snapped(Vector2.ONE).x
	var ydir = target.dir.snapped(Vector2.ONE).y
	
	if xdir == 1:
		play_blend(no_hook + "walk_right", 0.0)
		idle_dir = Vector2.RIGHT
	elif xdir == -1:
		play_blend(no_hook + "walk_left", 0.0)
		idle_dir = Vector2.LEFT
	elif xdir == 0:
		if ydir == 1:
			play_blend(no_hook + "walk_down", 0.0)
			idle_dir = Vector2.DOWN
		elif ydir == -1:
			play_blend(no_hook + "walk_up", 0.0)
			idle_dir = Vector2.UP
	
	# NOTE: Commenting out push/hop/fall states
	# get_wall_normal returns the direction the wall's collision is to us;
	# i.e. newton's second law, opposite reaction to our action
	# basically if we're on a collision & get_wall_normal matches the negative of our direction,
	# we're "pushing" against that object :) physics mf
	#if target.is_on_wall():
		#if target.get_wall_normal() == -target.dir:
			#curr_push_frame -= 1
			#if curr_push_frame <= 0:
				#curr_push_frame = push_frames
				#change_state("Push", target.dir)
		#else:
			## reset to default
			#curr_push_frame = push_frames
	
# when another state (such as attack or dash) transitions us out of this,
# set our velocity to zero so we don't get weird sliding
# if we have like, an ice level or slippery path, we prob wanna change this
func _on_exit(_args):
	target.velocity = Vector2.ZERO
	stop()
