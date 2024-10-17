@tool
extends StateSound


@export var jump_min_height := 16
@export var jump_max_height := 48
var entering_y := 0.0
var initial_target_position := Vector2.ZERO
var in_air := false


# FUNCTIONS AVAILABLE TO INHERIT

func _on_enter(_args) -> void:
	var _st = change_state("NoJump")

	entering_y = target.position.y
	initial_target_position = target.position

	# var jump_sound = target.get_node("Sounds/JumpSound")
	# jump_sound.play()
	# jump_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3


func _on_update(_delta) -> void:
	get_active_substate().jump()

	# Starts the air horizontal movement during the jump
	if target.velocity.x == 0 and target.dir != 0 and not target.is_on_wall():
		target.velocity = target.velocity.rotated(target.dir * PI/2)

	# This will keep the skin on the ground for a bit
	if !in_air:
		target.skin.position = target.position - initial_target_position

	# Keep the change of states at the end of the update
	# Will help to avoid unexpected behaviour happening after a change
	if not Input.is_action_pressed("ui_up"):
		if target.position.y < entering_y - jump_min_height:
			var _st = change_state("Fall")
	elif target.position.y < entering_y - jump_max_height:
		var _st = change_state("Fall")
	elif target.is_on_ceiling():
		var _st = change_state("Fall")


func _on_exit(_args) -> void:
	in_air = false
		

# CALLBACKS FROM AnimationPlayer

func _on_jump_finished() -> void:
	get_active_substate().play("Fall")


func _leave_ground():
	in_air = true
	target.skin.position = Vector2.ZERO
