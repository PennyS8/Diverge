@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	var nodes : Array[Node] = EditorInterface.get_selection().get_transformable_selected_nodes()
	var path = EditorInterface.get_selected_paths()[0]
	
	var replacement_node : PackedScene = load(path)
	for node in nodes:
		var pos = node.position
		var rot = node.rotation
		if replacement_node.can_instantiate():
			var scene : Node2D = replacement_node.instantiate()
			print(scene)
			scene.position = pos
			scene.rotation = rot
			node.add_sibling(scene)
			scene.name = "ComplexShade"
			scene.set_owner(get_scene())
			node.queue_free()
		else:
			print("can't instantiate")
