extends Line2D

@onready var arrow := $Arrow
@onready var primary := $Primary

func set_indicator(is_first, direction := Vector2.UP):
	if is_first:
		primary.show()
		arrow.hide()
	else:
		primary.hide()
		arrow.show()
		
		# We add a quarter rotation to the angle since the arrow's default direction is up rather than right
		# This effectively acts as an offset to reset the arrow's rotation to match the radian direction
		arrow.rotate(get_angle_to(to_global(direction)) + (PI / 2))
