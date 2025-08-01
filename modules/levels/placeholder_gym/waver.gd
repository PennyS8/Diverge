extends Sprite2D

var player : CharacterBody2D

var start_pos
@onready var shadow = $Shadow

func _ready():
	start_pos = Vector2.ZERO

func _process(delta):
	if !player:
		if LevelManager.player:
			player = LevelManager.player
			player.attack_swung.connect(player_swung_sword)
		else:
			return
	
	
func player_swung_sword():
	var player_dist = global_position.distance_to(player.global_position)
	var jump_time = player_dist / 500.0
	
	jump_in_secs(jump_time)
	
func jump_in_secs(seconds):
	await get_tree().create_timer(seconds).timeout
	
	var end_pos = Vector2(0, -18)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "offset", end_pos, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(shadow, "scale", Vector2(0.9, 0.9), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.chain()
	tween.tween_property(self, "offset", start_pos, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(shadow, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
