extends Area2D

@onready var barrier := $StaticBody2D

func _on_ready():
	barrier.position = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void:
	if barrier != null:
		if LevelManager.player.dialogue_tracker["library"]:
			barrier.position = Vector2.ZERO
		else:
			barrier.position = Vector2(48, 0)
