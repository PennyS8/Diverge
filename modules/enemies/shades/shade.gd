extends CharacterBody2D

@onready var _animation = $AnimationPlayer
@onready var _navagent = $NavigationAgent2D

@export var hitpoints = 10
@export var movement_speed : float = 30.0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass