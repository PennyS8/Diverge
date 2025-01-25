extends CharacterBody2D

@export var hitpoints = 10
@export var movement_speed : float = 30.0

@onready var status_holder = get_node("StatusHolder")

var follow_target

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_health_component_died() -> void:
	$ShadeFSM.change_state("Dead")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	if $HealthComponent.health > 0:
		$ShadeFSM.change_state("Stunned")
		# If the attacking _area is the players thread apply the tethered status effect
		if _area.is_in_group("thread"):
			status_holder.add_status("tethered")
	else:
		print("hi")

func pull():
	pass
	#var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
	#var tether_dir = player_pos.direction_to(global_position).normalized()
	#var new_pos = player_pos + tether_dir*THREAD_LENGTH
	#self.global_position = new_pos
