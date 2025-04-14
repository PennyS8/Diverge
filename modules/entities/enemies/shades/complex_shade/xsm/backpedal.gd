@tool
extends State

func _on_enter(_args) -> void:
	if EnemyManager.request_engagement(target):
		change_state("ChargeAttack")
	else:
		target.ai_steering.apply_flee(_args)
