@tool
extends State

@onready var agro_region : Area2D = %AgroRegion
@onready var soft_collision = %SoftCollision

@onready var movement_target_pos : Vector2
@export var nav_agent : NavigationAgent2D
@export var state_speed : float

func _on_enter(_args) -> void:
	target.movement_speed = state_speed

func _on_update(_delta: float) -> void:
	var possible_follow_targets = agro_region.get_overlapping_bodies()
	for follow_target in possible_follow_targets:
		if follow_target.is_in_group("player"):
			target.follow_object = follow_target
			change_state("Surprised")
	
	if nav_agent.is_navigation_finished():
		return
