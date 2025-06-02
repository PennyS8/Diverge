extends AnimatedSprite2D

@export var opacity_min : float = 0.0
@export var opacity_max : float = 1.0
@export var opacity_step : float = 0.25

func _ready():
	modulate.a = 0.0
	opacity_step = opacity_max / EnemyManager.MAX_METER
	EnemyManager.focus_updated.connect(update_progress)

func update_progress(new_value):
	var new_opacity = new_value * opacity_step
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).tween_property(self, "modulate:a", new_opacity, 0.15)
	if new_opacity < 1.0:
		tween.tween_interval(1.0)
		tween.set_trans(Tween.TRANS_BOUNCE).tween_property(self, "modulate:a", 0, 0.15)

	
