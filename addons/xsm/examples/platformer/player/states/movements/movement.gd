@tool
extends State


@export var gravity := 2500

# FUNCTIONS TO INHERIT #

func _on_update(delta):
	target.dir = 0

	if Input.is_action_pressed("ui_left"):
		target.dir = -1
	elif Input.is_action_pressed("ui_right"):
		target.dir = 1

	target.velocity.y += delta * gravity


func _after_update(_delta):
	# target.velocity = target.move_and_slide(target.velocity, Vector2.UP)
	target.move_and_slide()

	if target.velocity.x > 0:
		target.skin.scale.x = 1
	elif target.velocity.x < 0:
		target.skin.scale.x = -1
