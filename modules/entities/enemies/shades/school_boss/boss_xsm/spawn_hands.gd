@tool
extends StateSound

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	while EnemyManager.hand_spawn_counter.size() < EnemyManager.MAX_HANDS:
		var hand_scene = load("res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn")
		var hand_node = hand_scene.instantiate()
		
		var node = get_node(target.get_parent().get_path())
		node.add_child(hand_node)
				
		
		var boss_location = target.global_position
		var hand_location = boss_location + Vector2(48,24)
		
		hand_node.global_position = hand_location
		
		print("Spawning Hand")
		
		EnemyManager.add_hand(hand_node, hand_location)

func get_spawn_point(center : Vector2, radius : float) -> Vector2:
	# TAU = 2 * pi
	var angle = randf() * TAU
	var point = center + Vector2(cos(angle), sin(angle)) * radius
	
	return point

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass

# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass

# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass

# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
