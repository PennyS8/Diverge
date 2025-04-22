class_name EncounterArea
extends Area2D

@export var encounter_active := true

## The Marker2Ds to spawn enemies at. Ideally children of this node & referenced in array
@export var enemy_spawn_points : Array[Marker2D]

## The door blockers for enabled encounter
@export var door_closures : Array[StaticBody2D]

var current_enemies : Array[CharacterBody2D]
var enemy_packed : PackedScene = preload("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")

#region Savegame Stuff
func on_save_game(saved_data:Array[SavedData]):
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	my_data.puzzle_completed = encounter_active

	# Gets path up to node for reinstantiation
	my_data.parent_node_path = get_parent().get_path()
	
	my_data.child_nodes = pack_custom_children(my_data)
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	encounter_active = saved_data.puzzle_completed
	
	for node : PackedScene in saved_data.child_nodes:
		var child = node.instantiate()
		add_child(child)
	
	for path : NodePath in saved_data.enemy_spawn_points:
		var node = get_node_or_null(path)
		if node:
			enemy_spawn_points.append(node)
	
func pack_custom_children(savedata : SavedData):
	var packed_children : Array[PackedScene]
	for node in get_children():
		var packed_scene = PackedScene.new()
		packed_scene.pack(node)
		packed_children.append(packed_scene)
		
		if node is Marker2D and enemy_spawn_points.has(node):
			savedata.enemy_spawn_points.append(get_path_to(node))
	return packed_children

#endregion

#region Encounter Management

func start_encounter():
	# Move player camera to desired point & lock all doors
	# Spawn as many enemies as we have children that are marker2ds
	# connect each one's death to a function in here that removes them from a list
	# give control back to player
	if !encounter_active:
		return
	
	## To lock any transitions
	LevelManager.enter_encounter.emit()
	
	await get_tree().create_timer(2.0, true).timeout
	
	
	#await LevelManager.player.enter_cutscene(global_position)
	
	for spawnpoint in enemy_spawn_points:
		var enemy = enemy_packed.instantiate()

		add_sibling(enemy)
		
		enemy.fsm.change_state("Spawn")

		enemy.global_position = spawnpoint.global_position
		enemy.health_component.Died.connect(enemy_defeated.bind(enemy))
		
		current_enemies.append(enemy)
	
	await current_enemies[0].spawned
	#await LevelManager.player.exit_cutscene()

func end_encounter():
	# unlock all doors
	LevelManager.exit_encounter.emit()

	encounter_active = false

func enemy_defeated(enemy):
	if !current_enemies.has(enemy):
		return
	
	current_enemies.erase(enemy)
	
	if current_enemies.is_empty():
		end_encounter()

#endregion
