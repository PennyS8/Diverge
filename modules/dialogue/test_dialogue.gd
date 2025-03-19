extends BaseDialogueTestScene

func _ready() -> void:
	var balloon = load("res://modules/dialogue/portrait_balloon/dialogue_balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title)
