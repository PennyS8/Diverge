@tool
extends StateSound


@export var ground_friction := 10.0


# FUNCTIONS TO INHERIT #

# COMMENTED: DEFAULT ANIMATION IS SET IN THE INSPECTOR in Crouch State
# func _on_enter(_args):
# 	play("Brake")


func _on_update(_delta):
	target.velocity.x = lerp(target.velocity.x, 0.0, ground_friction * _delta)
