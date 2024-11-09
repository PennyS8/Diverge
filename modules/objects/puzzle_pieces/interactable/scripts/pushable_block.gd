extends CharacterBody2D

func push(direction : Vector2):
	direction = direction * $CollisionShape2D.shape.size.x
	var twe = create_tween()
	twe.tween_property(self, "global_position", global_position + direction, 0.2)
