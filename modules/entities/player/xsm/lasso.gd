@tool
extends StateSound


@onready var anim = $"../../../AnimationPlayer"
@onready var status_holder = $"../../../StatusHolder"
@onready var thread = $"../../../Thread"
@onready var sem = $/root/StatusEffectsManager

# Number of entities with the "tethered" status effect (EXCLUDING the player)
var prev_tethered

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	change_state("NoAttack")
	
	prev_tethered = sem.num_tethered_entities()
	
	var mouse_pos = target.get_global_mouse_position() + Vector2(0, 8)
	var attack_dir = target.global_position.direction_to(mouse_pos).normalized()
	thread.rotation = Vector2(0, 0).angle_to_point(attack_dir)

func _on_exit(_args) -> void:
	var curr_tethered = sem.num_tethered_entities()
	
	if prev_tethered == 0 and curr_tethered == 1:
		status_holder.add_status("tethered")
	elif prev_tethered == 1 and curr_tethered == 2:
		status_holder.remove_status("Tethered")
	else: # If no entities were hit by the thread
		pass
	
	change_state("CanAttack")
