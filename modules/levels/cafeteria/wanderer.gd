extends CharacterBody2D

func _ready():
	# this is for cafeteria
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2)

func set_path(end_position, time_to_travel):
	var tween = create_tween()
	tween.tween_property(self, "global_position", end_position, time_to_travel)
	tween.tween_callback(turn_around)
	
func turn_around():
	$Display/AnimatedSprite2D.play("walk_down")
