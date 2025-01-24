extends BaseDialogueTestScene

func _ready() -> void:
	var balloon = load("res://modules/dialogue/balloon/balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title)
	var testScene = load("res://modules/levels/debug/testing_grounds/testing_grounds.tscn")
	var scene_instance = testScene.instantiate()
	add_child(scene_instance)
