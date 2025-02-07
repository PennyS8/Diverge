extends CharacterBody2D

@export var hitpoints = 20
@export var movement_speed : float = 30.0

@onready var status_holder = get_node("StatusHolder")

var follow_target
var knockback : Vector2 = Vector2.ZERO
var crowd_control := false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	$AgroRegion.look_at(to_global(velocity))

func _on_health_component_died() -> void:
	$ShadeFSM.change_state("Dead")

func _on_hurt_box_component_2d_hit(_area : HitBoxComponent2D) -> void:
	if $HealthComponent.health > 0:
		knockback = _area.global_position.direction_to(global_position) * _area.knockback_coef
		$ShadeFSM.change_state("Stunned")
		$CPUParticles2D.restart()
		
		# If the attacking _area is the players thread apply the tethered status effect
		if _area.is_in_group("thread"):
			status_holder.add_status("tethered")
	else:
		$ShadeFSM.change_state("Dead")


func pull():
	pass
	#var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
	#var tether_dir = player_pos.direction_to(global_position).normalized()
	#var new_pos = player_pos + tether_dir*THREAD_LENGTH
	#self.global_position = new_pos


func _on_agro_region_body_exited(body):
	follow_target = null
	$ShadeFSM.change_state("Roaming")
