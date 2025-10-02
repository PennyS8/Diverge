extends Node

signal main_ready

var player : CharacterBody2D
var last_level_path : String
var last_level_name : String
var current_level_name : String
# Defaults entrance name to 0
var last_entrance : String = "0"
var new_entrance : String = "0"

func _ready():
	main_ready.connect(_main_ready)

func _main_ready():
	player = get_tree().get_first_node_in_group("player")

func respawn():
	current_level_name = LevelManager.current_level.name
	
	# Removes all enemies marked for engagement as well as all boss spawned enemies
	EnemyManager.remove_marked_enemies()
	
	# Removes the current encounter so that the blockers get despawned 
	remove_encounter()
	
	# Removes stress effect if it exists
	var player_noise = LevelManager.player.get_node("stressEffect")
	if player_noise: 
		player_noise.hide()
	
	if last_level_path == null:
		last_level_path = LevelManager.current_level.scene_file_path
	
	
	for entrance in get_tree().get_nodes_in_group("entrance_area"):
		if entrance.name == last_entrance:
			new_entrance = entrance.entrance_name
	
	LevelManager.respawn_transition(last_level_path, new_entrance)
	await LevelManager.swap_done
	SaveAndLoad.room_load(last_level_name)
	player.anim_player.play("RESET")
	player.fsm.change_state("Idle")
	await SaveAndLoad.load_player(last_level_name)
	
	player.set_collision_layer_value(3, true)
	var hud = get_tree().get_first_node_in_group("gui")

	player.health_component.alive = true
	player.health_component.health = player.health_component.max_health
	hud.heart_heal(player.health_component.max_health)

# Removes enemies that were spawned in the scene and saved.
func remove_spawned_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()

# Finds any active encounters and ends them to remove blockers.
func remove_encounter():
	var encounter_entrances = get_tree().get_nodes_in_group("encounter_entrance")
	for entrance in encounter_entrances:
		if entrance.is_currently_running:
			# Clears the enemy array from the encounter
			entrance.current_enemies.clear()
			
			entrance.end_encounter()
			# Sets the encounter back to active in order to allow for it to be triggered again.
			entrance.encounter_active = true
