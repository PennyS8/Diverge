extends StaticBody2D

@onready var particles = $CPUParticles2D

# load bearing unused param
func hit(area : HitBoxComponent2D):
	$Sprite2D/ShakerComponent2D.play_shake()
	particles.restart()

func _on_cpu_particles_2d_finished() -> void:
	if particles.amount == 16:
		queue_free()

func _on_health_component_died() -> void:
	particles.amount = 16
	$Sprite2D.visible = false
	set_collision_layer_value(5, false)
	set_collision_layer_value(6, false)
