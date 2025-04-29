extends Area2D

@export_file("*.tscn","*.scn") var next_level_path
@export var entrance_name : String
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

enum DirectionType { UP, DOWN, LEFT, RIGHT }
@export var transition_direction : DirectionType

var encounter_active := false

var blocker_packed = preload("res://modules/objects/level_transition_zone/blocker.tscn")
var blocker : StaticBody2D

func _ready():
	LevelManager.enter_encounter.connect(encounter_state.bind(true))
	LevelManager.exit_encounter.connect(encounter_state.bind(false))
	
func _on_body_entered(body: Node2D) -> void:
	if LevelManager.transitioning or encounter_active:
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

func encounter_state(state):
	match state:
		true:
			make_blocker()
			encounter_active = true
		false:
			break_blocker()
			encounter_active = false
			
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

func make_blocker():
	blocker = blocker_packed.instantiate()
	add_child(blocker)
	var blocker_pos : Vector2
	var vertical_firewall = blocker.get_node("FirewallVertical")
	var horizontal_firewall = blocker.get_node("FirewallHorizontal")
	blocker.modulate.a = 0.0
	match transition_direction:
		DirectionType.UP:
			blocker_pos = Vector2.UP
			horizontal_firewall.show()
			vertical_firewall.hide()
		DirectionType.DOWN:
			blocker_pos = Vector2.DOWN
			horizontal_firewall.show()
			vertical_firewall.hide()
		DirectionType.LEFT:
			blocker_pos = Vector2.LEFT
			horizontal_firewall.hide()
			vertical_firewall.show()
		DirectionType.RIGHT:
			blocker_pos = Vector2.RIGHT
			horizontal_firewall.hide()
			vertical_firewall.show()

	blocker_pos *= -5
	blocker.scale = Vector2.ONE / scale
	blocker.get_node("CollisionShape2D").scale = scale
	blocker.position = blocker_pos
	
	var tween = create_tween()
	tween.tween_property(blocker, "modulate:a", 1.0, 2.0)
	await tween.finished
	#vertical_firewall.global_position = blocker.global_position + Vector2(-20, -31.5)
	#horizontal_firewall.global_position = blocker.global_position + Vector2(-29, -7.5)
	

func break_blocker():
	if blocker:
		var tween = create_tween()
		tween.tween_property(blocker, "modulate:a", 0.0, 2.0)
		await tween.finished
		blocker.queue_free()
	
