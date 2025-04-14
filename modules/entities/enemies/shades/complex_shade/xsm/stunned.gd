@tool
extends StateSound

func _on_update(_delta: float) -> void:
	target.velocity = target.knockback
	target.move_and_slide()
	
	if target.crowd_control == true:
		# No knockback if the enemy is trapped
		target.knockback = lerp(Vector2.ZERO, Vector2.ZERO, 0.0)
	else:
		target.knockback = lerp(target.knockback, Vector2.ZERO, 0.2)

func _on_exit(_args) -> void:
	EnemyManager.mark_for_disengage(target)
