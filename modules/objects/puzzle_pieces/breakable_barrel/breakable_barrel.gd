extends StaticBody2D

@onready var particles = $CPUParticles2D

# load bearing unused param
func hit(_area : HitBoxComponent2D):
	$Sprite2D/ShakerComponent2D.play_shake()
	particles.restart()
	
	# If the thread is the attacking _area, apply the tethered status effect
	if _area.is_in_group("thread"):
		var status_node = load("res://modules/status_effects/tethered.tscn")
		var status = status_node.instantiate()
		var status_holder = get_node("StatusHolder")
		status_holder.add_child(status)
	


func _on_cpu_particles_2d_finished() -> void:
	if particles.amount == 16:
		queue_free()
	


func _on_health_component_died() -> void:
	particles.amount = 16
	$Sprite2D.visible = false
	set_collision_layer_value(5, false)
	set_collision_layer_value(6, false)
	
