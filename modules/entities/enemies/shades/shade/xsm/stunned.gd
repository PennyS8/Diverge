@tool
extends StateAnimation

## THIS STATE EXITS BASED ON THE CONDITIONS OF THE TIMER ATTACHED TO IT.
## WE POSSIBLY WANT TO PASS THIS IN AS A PARAMETER OR SOMETHING. THE TIMER IS FOR DEBUG.
## I LOVE YOU.

@onready var agro_region : Area2D = $"../../AgroRegion"

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the fchildren
func _on_update(_delta: float) -> void:
	var possible_follow_targets = agro_region.get_overlapping_bodies()
	for follow_target in possible_follow_targets:
		if follow_target.is_in_group("player"):
			target.follow_target = follow_target
			
	target.velocity = target.knockback
	target.move_and_slide()
	
	if target.crowd_control == true:
		# No knockback if the enemy is trapped
		target.knockback = lerp(Vector2.ZERO, Vector2.ZERO, 0.0)
	else:
		target.knockback = lerp(target.knockback, Vector2.ZERO, 0.2)

func _before_exit(_args):
	pass
	
