extends StaticBody2D

@export var key_id := 0
@export var toggled := false

# structural unused param
func flip(area):
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
