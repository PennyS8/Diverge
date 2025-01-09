extends CharacterBody2D

@export var hitpoints = 10
@export var movement_speed : float = 30.0

@onready var _animation = $AnimationPlayer
@onready var _navagent = $NavigationAgent2D
@onready var status_holder = get_node("StatusHolder")

const THREAD_LENGTH = 64

var follow_target

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _on_health_component_died() -> void:
	if $HealthComponent.health <= 0:
		$ShadeFSM.change_state("Dead")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	if $HealthComponent.health > 0:
		$ShadeFSM.change_state("Stunned")
		# If the attacking _area is the players thread apply the tethered status effect
		if _area.is_in_group("thread"):
			if get_tree().get_nodes_in_group("status_tethered").size() <= 1:
				status_holder.add_status("tethered")

func fling(fling_point : Vector2):
	var tween = create_tween()
	var tether_line = status_holder.get_node("Tethered").get_node("Line2D")
	
	if global_position.distance_to(fling_point) <= THREAD_LENGTH:
		tween.tween_property(self, "global_position", fling_point, 0.1)
	else:
		var fling_dir = global_position.direction_to(fling_point).normalized()
		var new_fling_point = global_position + fling_dir*THREAD_LENGTH
		tween.tween_property(self, "global_position", new_fling_point, 0.1)
	
	status_holder.get_parent().get_node("StatusHolder").remove_status("Tethered")

func pull():
	var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
	var tether_dir = player_pos.direction_to(global_position).normalized()
	var new_pos = player_pos + tether_dir*THREAD_LENGTH
	self.global_position = new_pos
