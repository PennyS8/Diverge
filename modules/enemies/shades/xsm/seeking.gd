@tool
extends State

@export var nav_agent : NavigationAgent2D
@export var movement_speed : float = 45

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var movement_target_pos : Vector2 = player.global_position

#
# FUNCTIONS TO INHERIT IN YOUR STATES
#
# Code related to nav_agent & tilemap integration are inspired by: 
# "Shifty the Dev"
# https://blog.shiftythedev.com/posts/GodotTilemapNavigation/
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_pos)


func set_movement_target(target_pos: Vector2):
	nav_agent.target_position = target_pos


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	movement_target_pos = player.global_position
	set_movement_target(movement_target_pos)
	
	if nav_agent.is_navigation_finished():
		change_state("Melee")
	
	var current_agent_position: Vector2 = target.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	target.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	target.move_and_slide()
	
	
	#
	#nav_agent.target_position = movement_target_pos
#
	##if we've already gotten to our player, we don't need to anymore
	#if nav_agent.is_navigation_finished():
		#state_machine.change_state("Melee")
	#
	#var current_agent_position: Vector2 = $"../../CollisionShape".global_position
	#var next_path_position: Vector2 = nav_agent.get_next_path_position()
	#parent.velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	#parent.move_and_slide()
	
	#state_machine.animation_player.play("walk")


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass
