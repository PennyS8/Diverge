extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.enter_encounter.connect(ring_ring)

func ring_ring():
	$AnimationPlayer.play("ring ring")
