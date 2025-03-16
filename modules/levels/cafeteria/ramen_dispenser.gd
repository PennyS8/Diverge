extends Node2D

@export var ramen_item : PackedScene

func dispense():
	for point in $DispensePoints.get_children():
		var ramen_instance : Node2D = ramen_item.instantiate()
		ramen_instance.name = "Ramen" + point.name
		point.add_child(ramen_instance)


func _on_debug_area_body_entered(body: Node2D) -> void:
	call_deferred("dispense")
