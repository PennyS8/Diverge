extends CharacterBody2D

var pushing := false

func push(direction : Vector2):
	direction = direction * $CollisionShape2D.shape.size.x
	if !move_and_collide(direction, true):
		if !pushing:
			pushing = true
			var twe = create_tween()
			twe.tween_property(self, "global_position", global_position + direction, 0.2)
			twe.finished.connect(set.bind("pushing", false))
		
