extends Resource
class_name Context

# Array that holds directional info as to where we want to go
# We will choose the highest value
# -INF means we will never go that direction
var context := []

func _init(size := 16):
	context.resize(size)
	# Initialize the array
	clear()

func clear():
	for i in context.size():
		context[i] = 0

# Returns a normalized vector of a given index in the array
func get_normal(idx : int):
	var angle = 2 * PI / context.size() * idx
	return Vector2.RIGHT.rotated(angle)

# Returns a normalized vector of where we want to go
func get_desired_normal():
	var max_idx = get_max_idx()
	if max_idx != -1:
		return get_normal(max_idx)
	else:
		return Vector2.ZERO

# Returns the index with the highest desirability
func get_max_idx():
	var max_idx = -1
	var max_value = 0
	for i in context.size():
		if context[i] > max_value:
			max_value = context[i]
			max_idx = i
	return max_idx
