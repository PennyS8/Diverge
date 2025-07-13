extends Node2D

@onready var rope = $Rope2
@onready var rope_end = $Node2D

var dir := Vector2.ZERO
var speed := 10

func _ready():
	rope.rope_length = $Node2D2.global_position.distance_to($Node2D.global_position)

func _process(delta: float) -> void:
	rope_end.position.x += delta * speed
	
	var dist = $Node2D2.global_position.distance_to($Node2D.global_position)
	
	if abs(dist - (rope.num_segments * rope.segment_length)) >= 2*rope.segment_length:
		rope.rope_length = dist
		rope.num_segments = ceil(dist / rope.num_segments)
		rope.update_segments()
