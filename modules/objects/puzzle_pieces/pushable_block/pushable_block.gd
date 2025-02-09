extends CharacterBody2D

var pushing := false

func push(area : HitBoxComponent2D):
	var direction = area.get_parent().swing_dir
	direction = direction * $BodyCollider.shape.size.x
	if !move_and_collide(direction, true):
		if !pushing:
			pushing = true
			var twe = create_tween()
			twe.tween_property(self, "global_position", global_position + direction, 0.2)
			twe.finished.connect(set.bind("pushing", false))
