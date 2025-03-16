extends TetherableBody

@export var spawns_wanderer : bool
func _ready():
	var end_pos = global_position + Vector2(0, 10)
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_pos, 0.2).set_trans(Tween.TRANS_CUBIC)
	if spawns_wanderer:
		call_deferred("spawn_wanderer")
	else:
		$TetherableArea2D.monitorable = true
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		queue_free()
		
func spawn_wanderer():
	var wanderer = load("res://modules/levels/cafeteria/wanderer.tscn")
	var wanderer_instance : CharacterBody2D = wanderer.instantiate()
	get_tree().current_scene.add_child(wanderer_instance)
	wanderer_instance.pick_up.connect(pick_up_tray)
	
	# set their location to a bit downwards, and their end location as our end_location
	wanderer_instance.global_position = get_parent().get_parent().global_position + Vector2(randi_range(-72, 72), randi_range(48, 72))
	wanderer_instance.set_path(global_position + Vector2(0, 30), randf_range(1, 1.5))
	
func pick_up_tray(body):
	reparent(body)
	position += Vector2(0,16)
