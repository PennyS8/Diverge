extends CharacterBody2D

const MOVE_SPEED := 2.0 * 24
const MIN_SEEK_DISTANCE := 24.0
const MAX_SEEK_DISTANCE := 32.0

@onready var neighbor_detector = $NeighborDetector

## Will move towards target if greater than this distance
var pursue_distance_max := randf_range(48.0, 64.0)
## Will move away from target if less than this distance
var pursue_distance_min := randf_range(16.0, 32.0)
var strafe_factor := 0.25

var ai_steering := AISteering.new()

func _physics_process(delta):
	
	var target_position = get_global_mouse_position()
	var displacement = target_position - global_position
	
	# Used to determine what we should push away from
	var neighbors = neighbor_detector.get_overlapping_bodies()
	neighbors.erase(self)
	
	var distance = displacement.length()
	var target_angle = displacement.angle()
	
	var seek_weight = Utils.map_value(distance, MIN_SEEK_DISTANCE, MAX_SEEK_DISTANCE)
	
	# Needs to be cleared at the start to reset data from last frame
	ai_steering.clear()
	# Avoid walls
	ai_steering.apply_collision_avoidance(self, 12.0)
		
	# Move towards target if too far away
	if distance > pursue_distance_max:
		ai_steering.apply_seek(target_angle)
		ai_steering.apply_strafe(target_angle, strafe_factor)
	# Move away from target if too close
	elif distance < pursue_distance_min:
		ai_steering.apply_flee(target_angle)
	# Within normal range, so just strafe
	else:
		ai_steering.apply_strafe(target_angle, strafe_factor)
	
	# Use a bias if seeking so we prefer our current direction
	ai_steering.apply_seek(velocity.angle(), 0.1)
	# Move away from nearby entities
	ai_steering.apply_separation(global_position, neighbors, 8.0)
	
	# Get the direction we want to move
	var normal = ai_steering.get_desired_normal()
	var desired_velocity = normal * MOVE_SPEED
	
	velocity = velocity.lerp(desired_velocity, 0.3)
	
	set_velocity(velocity)
	move_and_slide()
	velocity = velocity
