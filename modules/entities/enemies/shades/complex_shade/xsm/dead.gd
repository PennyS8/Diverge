@tool
extends StateSound

func _on_enter(_args) -> void:
	# Removes enemy from current engagers upon death
	EnemyManager.release_engagement(target)
