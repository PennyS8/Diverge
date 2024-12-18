extends CharacterBody2D

@onready var _animation = $AnimationPlayer
@onready var _navagent = $NavigationAgent2D

@export var hitpoints = 10
@export var movement_speed : float = 30.0

var follow_target


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func _on_health_component_died() -> void:
	if $HealthComponent.health <= 0:
		$ShadeFSM.change_state("Dead")


func _on_hurt_box_component_2d_hit() -> void:
	if $HealthComponent.health > 0:
		$ShadeFSM.change_state("Stunned")
