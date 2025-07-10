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
	# TODO: Set this up upon entering boss room so we don't have to have this code everywhere
	EnemyManager.remove_all_hands()
	EnemyManager.remove_boss_spawned_enemies()
	
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
