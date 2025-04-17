@tool
extends StateSound

const SPAWN_RADIUS = 96.0
const HAND_MARGIN = 12

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	while EnemyManager.hand_spawn_counter.size() < EnemyManager.MAX_HANDS:
		var hand_scene = load("res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn")
		var hand_node = hand_scene.instantiate()
		
		var node = get_node(target.get_parent().get_path())
		node.add_child(hand_node)
		
		var boss_location = target.global_position
		
		var hand_location = get_spawn_point(boss_location, SPAWN_RADIUS)
		var hand_x = hand_location.x
		var hand_y = hand_location.y
		
		# Only called if there are overlapping hands
		while EnemyManager.check_overlapping_hands(hand_x, hand_y, HAND_MARGIN) == true:
			hand_location = get_spawn_point(boss_location, SPAWN_RADIUS)
			hand_x = hand_location.x
			hand_y = hand_location.y
			
		
		hand_node.global_position = hand_location
		
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
