@tool
extends StateSound


# This function is called when the state enters
# XSM enters the root first, then the children
func _on_enter(_args) -> void:
	#var list : Array
	#var list2 : Array
	for entity in get_tree().get_nodes_in_group("status_tethered"):
		#if entity.name == "Player":
			#list.append(entity)
		#else:
			#list2.append(entity)
	#list.append_array(list2)
	#
	#for node in list:
		entity.get_node("StatusHolder").remove_status("tethered")
	
	change_state("Idle")
