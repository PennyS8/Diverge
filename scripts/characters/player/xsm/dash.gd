@tool
extends StateSound

@export var dash_speed := 400
@export var dash_distance := 128
var dash_direction := Vector2()
var start_location := Vector2()
var distance_travelled := 0
#
# FUNCTIONS TO INHERIT IN YOUR STATES
#	



func _on_enter(_args):
	start_location = target.global_position
	#TODO: when implementing controller, override this with analog stick direction instead of mouse pos
	dash_direction = start_location.direction_to(get_viewport().get_mouse_position()).normalized()
	
func _on_update(_delta):
	target.velocity = dash_direction * dash_speed
	distance_travelled = start_location.distance_to(target.global_position)
	
func _after_update(_delta):
	if distance_travelled >= dash_distance:
		target.velocity = Vector2.ZERO
		change_state("Idle")
	
	
