extends StaticBody2D

@onready var particles = $CPUParticles2D
@onready var health_component = $HealthComponent
@onready var status_holder = get_node("StatusHolder")

func on_save_game(saved_data:Array[SavedData]):
	# We do not need to save it if it is dead
	if health_component.health <= 0:
		return
	
	var my_data = SavedData.new()
	my_data.position = global_position
	my_data.scene_path = scene_file_path
	
	saved_data.append(my_data)

func on_before_load_game():
	get_parent().remove_child(self)
	queue_free()

func on_load_game(saved_data:SavedData):
	global_position = saved_data.position

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
	
