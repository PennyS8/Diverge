extends StaticBody2D

@onready var particles = $CPUParticles2D
@onready var status_holder = get_node("StatusHolder")

func hit(_area : HitBoxComponent2D):
	if _area.is_in_group("hook"):
		$Sprite2D/ShakerComponent2D.play_shake()
		particles.restart()

func pull():
	pass
	#var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
	#var tether_dir = player_pos.direction_to(global_position).normalized()
	#var new_pos = player_pos + tether_dir*THREAD_LENGTH
	#self.global_position = new_pos

func _on_cpu_particles_2d_finished() -> void:
	if particles.amount == 16:
		queue_free()

func _on_health_component_died() -> void:
	particles.amount = 16
	$Sprite2D.visible = false
	set_collision_layer_value(5, false)
	set_collision_layer_value(6, false)
	
