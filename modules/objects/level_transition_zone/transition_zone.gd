extends Area2D

@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

enum DirectionType { UP, DOWN, LEFT, RIGHT }
@export var transition_direction : DirectionType

func _on_body_entered(body: Node2D) -> void:
	if LevelManager.transitioning:
		return
		
	if body.is_in_group("player"):
		# Set just in case we didn't get it with the onready
		player = body
		
		#get_tree().change_scene_to_file("res://modules/levels/placeholder_mom_house/placeholder_home.tscn")
		var dir = DirAccess.open("user://")
		var file_name = "player_inventory"
		
		if dir.file_exists(file_name):
			GameManager.inventory_node.inventory.load_state("player_inventory")
		
		start_transition_cutscene()
		
		## Heal the player to max
		#var healthComponent = player.get_node_or_null("HealthComponent")
		#player.health_component.heal(healthComponent.max_health)

func start_transition_cutscene():
	var actual_dir : Vector2
	match transition_direction:
		DirectionType.UP:
			actual_dir = Vector2.UP
		DirectionType.DOWN:
			actual_dir = Vector2.DOWN
		DirectionType.LEFT:
			actual_dir = Vector2.LEFT
		DirectionType.RIGHT:
			actual_dir = Vector2.RIGHT
	
	LevelManager.player_transition(next_level_path, actual_dir, entrance_name)
