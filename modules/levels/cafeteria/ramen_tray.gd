extends Area2D

func _ready():
	var end_pos = global_position + Vector2(0, 10)
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 0.2)
	spawn_wanderer()
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		queue_free()
		
func spawn_wanderer():
	var wanderer = load("res://modules/levels/cafeteria/wanderer.tscn")
	var wanderer_instance : CharacterBody2D = wanderer.instantiate()
	get_tree().current_scene.add_child(wanderer_instance)
	
	# set their location to a bit downwards, and their end location as our end_location
	wanderer_instance.global_position = global_position + Vector2(0, 56)
	wanderer_instance.set_path(global_position + Vector2(0, 30), 2.0)
