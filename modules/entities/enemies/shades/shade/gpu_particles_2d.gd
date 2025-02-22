@tool
extends GPUParticles2D


func _process(_delta):
	material.set_shader_parameter("origin", global_position)
