class_name CameraBoundry
extends Area2D

@onready var top = $LimitTopRight.global_position.y
@onready var right = $LimitTopRight.global_position.x
@onready var bottom = $LimitBottomLeft.global_position.y
@onready var left = $LimitBottomLeft.global_position.x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
