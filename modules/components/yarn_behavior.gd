class_name YarnBehavior 
extends Resource

@export var frog_speed := 500.0
#pull towards calling object: (end_position, speed? <- may be derivative of mass of object)
func rip_it(target, knot_point : Vector2, end_position : Vector2):
	if target is CharacterBody2D:
		target.velocity = knot_point.direction_to(end_position) * frog_speed
		target.move_and_slide()
	elif target is RigidBody2D:
		target.apply_central_impulse(knot_point.direction_to(end_position) * frog_speed)
	
func entwine():
	pass
