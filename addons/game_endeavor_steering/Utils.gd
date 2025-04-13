extends Node
class_name Utils

static func map_value(value, min_value : float, max_value : float, will_clamp = true) -> float:
	if max_value > min_value:
		var map = (value - min_value) / (max_value - min_value)
		if will_clamp:
			map = clamp(map, 0.0, 1.0)
		return map
	else:
		return 1.0 if value >= min_value else 0.0
