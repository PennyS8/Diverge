extends Area2D

func _on_body_entered(body: Node2D) -> void:
	$"../EncounterEntrance".begin_encounter.connect(start_cutscene, CONNECT_ONE_SHOT)

func start_cutscene():
	DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "hall1_encounter", [self])
