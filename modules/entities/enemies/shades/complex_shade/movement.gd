@tool
extends StateAnimation

@export var nav_agent : NavigationAgent2D
@export var soft_collision : Area2D

const MIN_SEEK_DISTANCE := 24.0
const MAX_SEEK_DISTANCE := 32.0

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args):
	pass

func _on_update(_delta):
	var bodies = %AttackDetector.get_overlapping_bodies()
	if bodies != []:
		pass
		
	
# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta):
	## NATE: This is in after_update because we wait for any changes to 
	## the end position we make in child states before moving that way
#
	## Used to determine what we should push away from
	#var neighbors = soft_collision.get_overlapping_bodies()
	#neighbors.erase(self)
	#
	## Move away from nearby entities
	#target.ai_steering.apply_separation(target.global_position, neighbors, 8.0)
	##
	## Get the direction we want to move
	#var normal = target.ai_steering.get_desired_normal()
	#var desired_velocity = normal * target.movement_speed
	#
	#target.velocity = target.velocity.lerp(desired_velocity, 0.3)
	#target.set_velocity(target.velocity)
	#target.move_and_slide()
	#target.velocity = target.velocity
	animate_movement()

func animate_movement():
	var dir = target.velocity.normalized()
	var xdir = dir.snapped(Vector2.ONE).x
	var ydir = dir.snapped(Vector2.ONE).y
	
	var idle_dir = "down"
	match [xdir, ydir]:
		[1.0, _]:
			play_blend("walk_right", 0.0)
			idle_dir = "right"
		[-1.0, _]:
			play_blend("walk_left", 0.0)
			idle_dir = "left"
		[0.0, 1.0]:
			play_blend("walk_down", 0.0)
			idle_dir = "down"
		[0.0, -1.0]:
			play_blend("walk_up", 0.0)
			idle_dir = "up"
		[0.0, 0.0]:
			play_blend("idle_"+idle_dir, 0.0)

# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args):
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args):
	pass


# when StateAutomaticTimer timeout()
func _state_timeout():
	pass


# Called when any other Timer times out
func _on_timeout(_name):
	pass
