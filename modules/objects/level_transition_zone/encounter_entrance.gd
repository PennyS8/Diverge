class_name EncounterBoundry
extends CameraBoundry

@export var encounter_active := true
## The points to spawn enemies at. Ideally children of this node & assigned by developer
@export var enemy_spawn_points : Array[Marker2D]
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
	
	my_data.child_nodes = pack_custom_children()
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
	
func pack_custom_children():
	var packed_children : Array[PackedScene]
	for node in get_children():
		var packed_scene = PackedScene.new()
		packed_scene.pack(node)
		packed_children.append(packed_scene)
	return packed_children
	
func update_boundaries(top_right, bottom_left):
	top = top_right.global_position.y
	right = top_right.global_position.x
	bottom = bottom_left.global_position.y
	left = bottom_left.global_position.x
#endregion

#region Encounter Management

func start_encounter():
	# Move player camera to desired point & lock all doors
	# Spawn as many enemies as we have children that are marker2ds
	# connect each one's death to a function in here that removes them from a list
	# give control back to player
	if !encounter_active:
		return
	
	LevelManager.player.enter_cutscene(global_position)
	
	for spawnpoint in enemy_spawn_points:
		var enemy = enemy_packed.instantiate()
		add_child(enemy)
		
		enemy.global_position = spawnpoint.global_position
		enemy.fsm.change_state("Spawn")
		enemy.health_component.Died.connect(enemy_defeated.bind(enemy))
		
		current_enemies.append(enemy)

func end_encounter():
	# unlock all doors
	encounter_active = false

func enemy_defeated(enemy):
	if !current_enemies.has(enemy):
		return
	
	current_enemies.erase(enemy)
	
	if current_enemies.is_empty():
		end_encounter()

#endregion
