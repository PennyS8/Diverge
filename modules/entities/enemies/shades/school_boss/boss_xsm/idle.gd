@tool
extends StateSound

const SPAWN_RADIUS = 96.0
const HAND_MARGIN = 12
const SHADE_COUNT = 3

var shade_scene = preload("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")
var hand_scene = preload("res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn")

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	pass
	#spawn_shades()

# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	while EnemyManager.hand_spawn_counter.size() < EnemyManager.MAX_HANDS:
		var hand_node = shade_scene.instantiate()
		
		# Gets path of boss in the tree and adds child to same path
		var node = get_node(target.get_parent().get_path())
		node.add_child(hand_node)
		
		# Sets hands spawn point to random point on boss's radius 
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
		EnemyManager.add_boss_spawned_enemy(hand_node)

# Helper function to get a randomized point on a radius
func get_spawn_point(center : Vector2, radius : float) -> Vector2:
	# TAU = 2 * pi
	var angle = randf() * TAU
	var point = center + Vector2(cos(angle), sin(angle)) * radius
	
	return point

# Simple helper method to spawn regular shades
func spawn_shades(): 
	for i in range(1, SHADE_COUNT):
		var shade_node = shade_scene.instantiate()
		
		# Gets path of boss in the tree and adds child to same path
		var node = get_node(target.get_parent().get_path())
		node.add_child(shade_node)
		
		var boss_location = target.global_position
		shade_node.global_position = get_spawn_point(boss_location, SPAWN_RADIUS)
		
		EnemyManager.add_boss_spawned_enemy(shade_node)

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
