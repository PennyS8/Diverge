extends Node

var nates_ground_item = preload("res://modules/objects/inventory_helpers/NatesGroundItem.tscn")

## Returns the amount of adds that were successful
func add_itemtype_to_inventory(inventory : Inventory, item_type : ItemType, quantity : int) -> int:
	var stack = ItemStack.new(item_type, quantity, null)
	return inventory.try_add_item(stack)

func is_itemtype_in_inventory(inventory : Inventory, item_type : ItemType):
	var arbitrary_array_of_item = [item_type]
	if inventory.count_items(arbitrary_array_of_item):
		return true
	else:
		return false
		
func is_itemlist_in_inventory(inventory : Inventory, item_list : Array[ItemLike]):
	if inventory.count_items(item_list):
		return true
	else:
		return false

func is_inventory_empty(inventory : Inventory):
	if inventory.count_all_items() == {}:
		return true
	else:
		return false

func add_ground_item(item_type : ItemType, pos : Vector2, parent_node : Node):
	var item_instance = nates_ground_item.instantiate()
	item_instance.ground_item = item_type
	parent_node.add_child(item_instance)
	item_instance.global_position = pos
