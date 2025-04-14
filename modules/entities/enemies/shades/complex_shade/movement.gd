@tool
extends StateAnimation

@export var soft_collision : Area2D

const MIN_SEEK_DISTANCE := 24.0
const MAX_SEEK_DISTANCE := 32.0

func _after_update(_delta):
	## This is in after_update because we wait for any changes to 
	## the end position we make in child states before moving that way
	
	# Get the direction we want to move
	var normal = target.ai_steering.get_desired_normal()
	var desired_velocity = normal * target.movement_speed
	
	target.velocity = target.velocity.lerp(desired_velocity, 0.3)
	
	target.set_velocity(target.velocity)
	target.move_and_slide()
	target.velocity = target.velocity
	
	animate_movement()

func animate_movement():
	if !target.follow_object:
		return
	
	var dir = target.global_position.direction_to(target.follow_object.global_position).normalized()
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
