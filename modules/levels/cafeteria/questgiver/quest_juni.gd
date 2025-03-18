extends StaticBody2D

@export var item_type : ItemType

func _ready():
	InventoryHelper.add_ground_item(item_type, global_position+Vector2(-24, -24), self)

func _on_interaction_circle_body_entered(body: Node2D) -> void:
	body.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/cafeteria/questgiver/juni_hungry.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
	
func _test_if_ramen() -> bool:
	var inv : Inventory = GameManager.inventory_node.inventory
	if InventoryHelper.is_itemtype_in_inventory(inv, item_type):
		inv.consume_items({item_type: 1})
		return true
	else:
		return false
