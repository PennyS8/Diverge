@tool
extends BTAction

# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "DisengageEnemy"


# Called to initialize the task.
func _setup() -> void:
	pass


# Called when the task is entered.
func _enter() -> void:
	EnemyManager.release_engagement(agent)
		


# Called when the task is exited.
func _exit() -> void:
	pass

# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
