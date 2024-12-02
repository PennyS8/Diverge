extends Area2D

@export var speed := 1.5

func _physics_process(_delta: float) -> void:
	position += transform.x * speed


func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	queue_free()
