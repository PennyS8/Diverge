extends Rope

@onready var rope_end = $"../Projectile/RopeHandle"
@onready var end_point = rope_end.global_position

const segment_length : float = 8.0

func _process(delta: float) -> void:
	var dist = position.distance_to(end_point)
	rope_length = dist
	num_segments = ceil(dist / segment_length)
