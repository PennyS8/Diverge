@tool
extends StateSound

const SPAWN_RADIUS = 96.0
const SHADE_MARGIN = 12
const SHADE_COUNT = 3

var shade_scene = preload("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")
var hand_scene = preload("res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn")
var spawn = false

func _on_enter(_args) -> void:
	# Adds delay to allow for player to load in before boss spawns
	add_timer("SpawnDelay", 1.0)

func _on_update(_delta: float) -> void:
	var stack_found = false
	for enemy in EnemyManager.hand_spawn_counter:
		if enemy:
			if enemy.name == "ShadeStack":
				stack_found = true
	
	if spawn and !stack_found:
		if EnemyManager.hand_spawn_counter.size() < EnemyManager.MAX_HANDS:
			## TODO: Change this to spawn hands instead of shades after graduation
			var shade_node = shade_scene.instantiate()
			
			# Gets path of boss in the tree and adds child to same path
			var node = get_node(target.get_parent().get_path())
			node.add_child(shade_node)
			
			# Sets hands spawn point to random point on boss's radius 
			var boss_location = target.global_position
			var shade_location = get_spawn_point(boss_location, SPAWN_RADIUS)
			var shade_x = shade_location.x
			var shade_y = shade_location.y
			
			# Only called if there are overlapping hands
			while EnemyManager.check_overlapping_hands(shade_x, shade_y, SHADE_MARGIN) == true:
				shade_location = get_spawn_point(boss_location, SPAWN_RADIUS)
				shade_x = shade_location.x
				shade_y = shade_location.y
			
			shade_node.hurtbox.set_collision_mask_value(3, false)
			shade_node.tetherable_area.set_collision_layer_value(9, false)
			shade_node.visible = false
			shade_node.fsm.change_state_node_force(shade_node.get_node("%Spawn"))
			shade_node.global_position = shade_location
			
			EnemyManager.add_hand(shade_node, shade_location)
			EnemyManager.add_boss_spawned_enemy(shade_node)

# Helper function to get a randomized point on a radius
func get_spawn_point(center : Vector2, radius : float) -> Vector2:
	# TAU = 2 * pi
	var angle = randf() * TAU
	var point = center + Vector2(cos(angle), sin(angle)) * radius
	
	return point

# Simple helper method to spawn regular shades
## NOTE: This function will be used once hands are implemented
func spawn_shades(): 
	for i in range(1, SHADE_COUNT):
		var shade_node = shade_scene.instantiate()
		
		# Gets path of boss in the tree and adds child to same path
		var node = get_node(target.get_parent().get_path())
		node.add_child(shade_node)
		
		var boss_location = target.global_position
		shade_node.global_position = get_spawn_point(boss_location, SPAWN_RADIUS)
		
		EnemyManager.add_boss_spawned_enemy(shade_node)

# Called when any other Timer times out
func _on_timeout(_name) -> void:
	spawn = true
