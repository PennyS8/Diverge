extends Node2D

@onready var ledge_top = $LedgeTop
@onready var ledge_bottom = $LedgeBottom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var possible_bodies = ledge_top.get_overlapping_bodies()
	for body in possible_bodies:
		if body.is(CharacterBody2D): #if body.is_in_group("Player"):
			
			# TODO: Check if body has constant velocity for duration
			
			var start_pos = body.global_position
			var end_pos = calculate_drop_pos(start_pos)
			
			drop_anim(body, start_pos, end_pos)

func calculate_drop_pos(start_pos: Vector2) -> Vector2:
	var relative_pos = start_pos - ledge_top.global_position
	
	var relative_pos_by_perc : Vector2
	relative_pos_by_perc.x = relative_pos.x / (ledge_top.size.x/2)
	relative_pos_by_perc.y = relative_pos.y / (ledge_top.size.y/2)
	
	var translated_pos_by_perc : Vector2
	translated_pos_by_perc.x = relative_pos_by_perc.x * (ledge_bottom.size.x/2)
	translated_pos_by_perc.y = relative_pos_by_perc.y * (ledge_bottom.size.y/2)
	
	var goal_pos = translated_pos_by_perc + ledge_bottom.global_position
	
	return goal_pos

func drop_anim(agent: CharacterBody2D, start_pos: Vector2, end_pos: Vector2) -> void:
	# TODO: Set up a tween between the start_pos and end_pos for the agent
	# TODO: Scale the sprite to grow and shrink back to its normal scale in a bell curve
	pass
	
