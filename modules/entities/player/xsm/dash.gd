@tool
extends StateSound

@export var dash_speed := 400
@export var dash_distance := 128
var dash_direction := Vector2()
var start_location := Vector2()
var distance_travelled := 0
var walled : bool
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#	

func _on_enter(_args):
	change_state("NoAttack")
	start_location = target.global_position
	#TODO: when implementing controller, override this with analog stick direction instead of mouse pos
	var mouse_pos = target.get_global_mouse_position()
	dash_direction = start_location.direction_to(mouse_pos).normalized()
	distance_travelled = 0

func _on_update(_delta):
	target.velocity = dash_direction * dash_speed
	distance_travelled = distance_travelled + (target.velocity * _delta).length()

func _after_update(_delta):
	if distance_travelled >= dash_distance:
		target.velocity = Vector2.ZERO
		change_state("Idle")

func _on_exit(_args):
	change_state("DashTimer")
