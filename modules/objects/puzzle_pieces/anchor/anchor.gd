extends TetherableBody

# Overrides for tethered functionalities
func pull(): # Between self and another body
	pass
func fling(): # Between self and player
	pass

func _on_tetherable_area_2d_mouse_exited() -> void:
	deselect()

func _on_tetherable_area_2d_mouse_entered() -> void:
	select()
