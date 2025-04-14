@tool
extends StateAnimation

var dash_dust : PackedScene = preload("res://modules/entities/player/dash_dust.tscn")
var dust_anims : Dictionary = {
	Vector2.UP: "up", 
	Vector2(-1, -1): "left_up",
	Vector2(1, -1): "right_up",
	Vector2.RIGHT: "right_down",
	Vector2(1, 1): "right_down",
	Vector2.DOWN: "down",
	Vector2(-1, 1): "left_down",
	Vector2.LEFT: "left_down",
}

## The end position of our attack dash in local space
var end_position : Vector2

## The amount of time our dash lasts
@export var dash_duration := 0.25
@export var dash_distance := 48.0

var dash_velocity
var remaining_time

func _on_enter(_args) -> void:
	remaining_time = dash_duration
	var my_position = target.global_position
	var player_position = target.follow_object.global_position
	
	var attack_direction = my_position.direction_to(player_position).normalized()
	end_position = attack_direction * dash_distance
	
	dash_velocity = end_position / dash_duration
	pick_attack_anim()
	
	var dust_dir = attack_direction.snapped(Vector2.ONE)
	var dust = dash_dust.instantiate()
	get_tree().current_scene.add_child(dust)
	dust.global_position = target.global_position
	dust.play(dust_anims[dust_dir])

func _on_update(_delta: float) -> void:
	if remaining_time > 0.0:
		target.velocity = dash_velocity
		target.move_and_slide()
		remaining_time -= _delta
	else:
		change_state("Chase")
	
	#target.velocity

func _on_exit(_args) -> void:
	EnemyManager.mark_for_disengage(target)

func pick_attack_anim():
	var my_position = target.global_position
	var attack_position = target.follow_object.global_position
	
	var attack_direction = my_position.direction_to(attack_position).normalized()
	var xdir = attack_direction.snapped(Vector2.ONE).x
	var ydir = attack_direction.snapped(Vector2.ONE).y
	
	match [xdir, ydir]:
		[1.0, _]:
			play_blend("attack_right", 0.0)
		[-1.0, _]:
			play_blend("attack_left", 0.0)
		[0.0, 1.0]:
			play_blend("attack_down", 0.0)
		[0.0, -1.0]:
			play_blend("attack_up", 0.0)
		[_, _]:
			play_blend("attack_down", 0.0)
