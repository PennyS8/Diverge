extends Area2D

func dash():
	var tween = create_tween()

	$AnimatedSprite2D.play("dash_left")
	tween.tween_property(self, "global_position", global_position-Vector2(170,0), 1)
	await tween.finished
	return
