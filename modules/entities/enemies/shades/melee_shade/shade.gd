extends CharacterBody2D

@onready var _animation = $AnimationPlayer
@onready var _navagent = $NavigationAgent2D

@export var hitpoints = 10
@export var movement_speed : float = 30.0

var default_position
var follow_target

func on_save_game(saved_data:Array[SavedData]):
	if $HealthComponent.health <= 0: 
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position
	default_position = saved_data.position

func _ready() -> void:
	default_position = global_position


func _physics_process(delta: float) -> void:
	pass


func _on_health_component_died() -> void:
	if $HealthComponent.health <= 0:
		$ShadeFSM.change_state("Dead")


func _on_hurt_box_component_2d_hit() -> void:
	if $HealthComponent.health > 0:
		$ShadeFSM.change_state("Stunned")
