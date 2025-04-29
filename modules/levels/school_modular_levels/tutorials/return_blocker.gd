extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if !LevelManager.transitioning:
		if body.is_in_group("player"):
			var dialogue = load("res://modules/levels/school_modular_levels/tutorials/tutorials.dialogue")
			DialogueManager.show_dialogue_balloon(dialogue, "return_library_blocked")
