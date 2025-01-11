extends StaticBody2D

@onready var particles = $CPUParticles2D
@onready var status_holder = get_node("StatusHolder")
@onready var sem = $/root/StatusEffectsManager

const THREAD_LENGTH = 64

func hit(_area : HitBoxComponent2D):
	# If the attacking _area is the players thread apply the tethered status effect
	if _area.is_in_group("thread"):
		var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
		if status_holder.get_node("Tethered"):
			pass
		else:
			status_holder.add_status("tethered")
		
	elif _area.is_in_group("hook"):
		$Sprite2D/ShakerComponent2D.play_shake()
		particles.restart()

func fling(fling_point : Vector2):
	pass
	#var tween = create_tween()
	#var tether_line = status_holder.get_node("Tethered").get_node("Line2D")
	#
	#if global_position.distance_to(fling_point) <= THREAD_LENGTH:
		#tween.tween_property(self, "global_position", fling_point, 0.1)
	#else:
		#var fling_dir = global_position.direction_to(fling_point).normalized()
		#var new_fling_point = global_position + fling_dir*THREAD_LENGTH
		#tween.tween_property(self, "global_position", new_fling_point, 0.1)
	#
	#status_holder.get_parent().get_node("StatusHolder").remove_status("Tethered")

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
	
