extends StaticBody2D

@export var key_id := 0
@export var toggled := false

@onready var status_holder = get_node("StatusHolder")

func hit(_area : HitBoxComponent2D):
	# If the attacking _area is the players thread apply the tethered status effect
	if _area.is_in_group("thread"):
		if get_tree().get_nodes_in_group("status_tethered").size() <= 0:
			add_to_group("status_tethered")
			
			var status_node = load("res://modules/status_effects/tethered.tscn")
			var status = status_node.instantiate()
			status_holder.add_child(status)
	
	elif _area.is_in_group("hook"):
		flip()

func fling(fling_point : Vector2):
	var fling_dir = global_position.direction_to(fling_point).normalized()
	
	# this logic is so that we find which of the four cardinals our mouse is \
	# closest to. whichever absolute value is larger determines which \
	# component (x or y) we want to take as the main value.
	var component_x = abs(fling_dir.x)
	var component_y = abs(fling_dir.y)
	if abs(fling_dir.x) > abs(fling_dir.y):
		# The lever is being pulled left or right enough to be flipped
		# TODO: verify lefts and rights are not swapped
		if toggled and fling_dir.x > 0:
			flip() # if lever is right and pulled left, flip
		elif !toggled and fling_dir.x < 0:
			flip() # if lever is left and pulled right, flip

func flip():
	if !toggled:
		toggled = true
		$Sprite2D.frame = 1
		$Sprite2D.offset.x = -8
		KeyChain.key.emit(key_id, true)
	else:
		toggled = false
		$Sprite2D.frame = 0
		$Sprite2D.offset.x = 8
		KeyChain.key.emit(key_id, false)
