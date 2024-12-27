extends StatusEffectClass

const THREAD_LENGTH = 64

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
	
	if global_position.distance_to(player_pos) > THREAD_LENGTH:
		get_parent().get_parent().pull() # pull() func of the tethered entity scriptt
	
	var realtive_player_pos = player_pos - global_position
	$Line2D.points[1] = realtive_player_pos
