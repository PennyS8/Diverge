extends TetherableBody

func set_substance_type(item : ItemType):
	pass

func pull():
	$Item.set_collision_mask_value(4, false)
	super.pull()
	
func fling():
	$AudioStreamPlayer2D.play()
	$Item.set_collision_mask_value(4, false)
	super.fling()
