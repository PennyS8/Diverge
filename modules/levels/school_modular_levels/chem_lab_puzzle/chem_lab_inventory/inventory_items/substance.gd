extends TetherableBody

@export var item_type : ItemType

@onready var sprite = $CanvasGroup/Sprite2D

func set_substance_type(item : ItemType):
	item_type = item
	
	sprite.texture = item.texture
	
	var item_item = ItemStack.new(item, 1, null)
	$Item.item_stack = item_item

func pull():
	$Item.set_collision_mask_value(4, false)
	super.pull()
	
func fling():
	$AudioStreamPlayer2D.play()
	$Item.set_collision_mask_value(4, false)
	super.fling()
