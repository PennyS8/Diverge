@tool
extends StateSound

# dictionary allows us to get which attack state to get from which cardinal
# our mouse is closest to
var attack_states : Dictionary = {
	Vector2.UP: "AttackUp", 
	Vector2.RIGHT: "AttackRight",
	Vector2.DOWN: "AttackDown",
	Vector2.LEFT: "AttackLeft"
	}

@export var attack_nudge_speed := 250
@export var attack_nudge_distance := 16

# used for calculating hook swing direction (up, down, left right)
# as well as nudge direction (360deg)
var attack_dir : Vector2
var swing_dir : Vector2
var start_location : Vector2
var distance_travelled : float

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	var mouse_pos = target.get_global_mouse_position()  
	
	start_location = target.global_position
	attack_dir = start_location.direction_to(mouse_pos).normalized()
	distance_travelled = 0
	
	# this logic is so that we find which of the four cardinals our mouse is \
	# closest to. whichever absolute value is larger determines which \
	# component (x or y) we want to take as the main value.
	var component_x = abs(attack_dir.x)
	var component_y = abs(attack_dir.y)
	
	swing_dir = attack_dir
	if component_x > component_y:
		swing_dir.y = 0
	if component_y > component_x:
		swing_dir.x = 0
	
	# .snapped(Vector2.ONE) would normally round to the nearest of the 
	# 8 cardinal dirs, but since we got rid of the non-major component it will
	# only be the 4 main cardinals (up, down, left, right)
	swing_dir = swing_dir.snapped(Vector2.ONE)
	
	target.swing_dir = swing_dir
	target.idle_dir = swing_dir
	# our four cardinals are:
	# UP: (0,-1)
	# RIGHT: (1,0)
	# DOWN: (0, 1)
	# LEFT: (-1, 0)
	# the dictionary initialized at the top of this script assigns each vector2
	# value to the corresponding state node name
	change_state(attack_states[swing_dir])
	target.attack_swung.emit()


# pretty much same logic as dash for these two functions.
func _on_update(_delta):
	target.velocity = attack_dir * attack_nudge_speed
	distance_travelled = distance_travelled + (target.velocity * _delta).length()
	

func _after_update(_delta):
	if distance_travelled >= attack_nudge_distance:
		target.velocity = Vector2.ZERO

func change_to_next_substate():
	change_state("Idle")
