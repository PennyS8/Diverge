extends StaticBody2D

@export var health = 6
@onready var particles = $CPUParticles2D

func hit(damage : float):
	health -= damage
	if health <= 0:
		particles.amount = 16
		$Sprite2D.visible = false
		set_collision_layer_value(5, false)
		set_collision_layer_value(6, false)
	
	$Sprite2D/ShakerComponent2D.play_shake()
	particles.restart()

func _on_cpu_particles_2d_finished() -> void:
	if particles.amount == 16:
		queue_free()
