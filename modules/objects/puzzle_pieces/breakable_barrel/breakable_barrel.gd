extends StaticBody2D

@onready var particles = $CPUParticles2D
@onready var status_holder = get_node("StatusHolder")

func hit(_area : HitBoxComponent2D):
	# If the attacking _area is the players thread apply the tethered status effect
	if _area.is_in_group("thread"):
		if get_tree().get_nodes_in_group("status_tethered").size() <= 0:
			status_holder.add_status("tethered")
		
	elif _area.is_in_group("hook"):
		$Sprite2D/ShakerComponent2D.play_shake()
		particles.restart()

func fling(fling_point : Vector2):
	global_position = fling_point
	#status_holder.remove_status("tethered")

func _on_cpu_particles_2d_finished() -> void:
	if particles.amount == 16:
		queue_free()

func _on_health_component_died() -> void:
	particles.amount = 16
	$Sprite2D.visible = false
	set_collision_layer_value(5, false)
	set_collision_layer_value(6, false)
	
