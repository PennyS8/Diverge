@tool
extends StateAnimation

# The amount of time before we transition to the actual attack
@export var charge_time : float
var remaining_time : float

func _on_enter(_args) -> void:
	remaining_time = charge_time
	pick_charge_anim()

func pick_charge_anim():
	var my_position = target.global_position
	var attack_position = target.follow_object.global_position
	
	var attack_direction = my_position.direction_to(attack_position).normalized()
	var xdir = attack_direction.snapped(Vector2.ONE).x
	var ydir = attack_direction.snapped(Vector2.ONE).y
	
	match [xdir, ydir]:
		[1.0, _]:
			play_blend("charge_right", 0.0)
		[-1.0, _]:
			play_blend("charge_left", 0.0)
		[0.0, 1.0]:
			play_blend("charge_down", 0.0)
		[0.0, -1.0]:
			play_blend("charge_up", 0.0)
		[_, _]:
			play_blend("charge_down", 0.0)

func _on_update(_delta: float) -> void:
	if remaining_time <= 0:
		change_state("Attack")
	
	remaining_time -= _delta
