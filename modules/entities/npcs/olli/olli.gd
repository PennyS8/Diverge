extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

var dir : Vector2

func do_walk(global_point : Vector2):
	var postAnim: String
	dir = global_position.direction_to(global_point)
	dir = dir.snapped(Vector2.ONE)
	
	
	match dir:
		Vector2.UP:
			sprite.play("walk_up")
			postAnim = "idle_up"
		Vector2.DOWN:
			sprite.play("walk_down")
			postAnim = "idle_down"
		Vector2.LEFT:
			sprite.play("walk_left")
			postAnim = "idle_left"
		Vector2.RIGHT:
			sprite.play("walk_right")
			postAnim = "idle_right"
			
			
	var dist = global_position.distance_to(global_point)
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_point, (dist/60.0))
	await tween.finished
	sprite.play(postAnim)
