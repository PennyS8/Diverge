extends TetherableBody

@export var item_type : ItemType

@onready var sprite = $CanvasGroup/Sprite2D

func set_substance_type(item : ItemType):
	item_type = item
	
	sprite.texture = item.texture
	
	var item_item = ItemStack.new(item, 1, null)
	$Item.item_stack = item_item

func _on_item_body_entered(body: Node2D) -> void:
	# Stops being tetherable
	$TetherableArea2D.set_deferred("monitorable", false)
	$Item.set_deferred("monitorable", false)
	
	var inventory = GameManager.inventory_node.inventory
	$Item.try_pickup(inventory)
	
	# Removes itself from scene once picked up.
	queue_free()

func pull():
	$Item.set_collision_mask_value(4, false)
	super.pull()
	
func fling():
	$Item.set_collision_mask_value(4, false)
	super.fling()
