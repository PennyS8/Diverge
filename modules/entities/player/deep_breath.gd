@tool
extends State

@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var hurt_box = $"../../../HurtBoxComponent2D"

# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	hurt_box.monitoring = false
	hurt_box.monitorable = false
	
	print("Coping")
	
	await LevelManager.deep_breath_overlay()
	change_state("Inactive")

func _on_exit(_args) -> void:
	
	print("Coped")
	
	hurt_box.monitoring = true
	hurt_box.monitorable = true
