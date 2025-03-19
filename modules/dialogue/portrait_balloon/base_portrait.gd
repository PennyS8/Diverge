class_name BasePortrait extends Node2D


@export var animation_player: AnimationPlayer


func emote(tags: Array) -> void:
	if not is_instance_valid(animation_player): return

	for tag in tags:
		if animation_player.has_animation(tag):
			animation_player.play(tag)
