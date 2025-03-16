extends CharacterBody2D

signal pick_up(body)

func _ready():
	# this is for cafeteria
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)
	
func set_path(end_position, time_to_travel):
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_position, time_to_travel)
	tween.tween_callback(pick_up.emit.bind(self))
	tween.tween_callback(turn_around)
	
func turn_around():
	$Display/AnimatedSprite2D.play("walk_down")
	var tween = create_tween().set_parallel(true)
	var end_position = global_position + Vector2(randi_range(-24, 24), randi_range(24, 32))
	tween.tween_property(self, "global_position", end_position, 2.0)
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	tween.chain().tween_callback(queue_free)
