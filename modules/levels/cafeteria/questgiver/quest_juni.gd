extends StaticBody2D

@export var item_type : ItemType
@export var return_item : ItemType
@onready var table_book = $TableBook
@onready var table_ramen = $TableRamen
@onready var player = get_tree().get_first_node_in_group("player")
var interactable
var quest_done : bool = false
var talked_to : bool = false
func _ready():
	#InventoryHelper.add_ground_item(item_type, global_position+Vector2(-24, -24), self)
	pass
	
func _unhandled_input(_event: InputEvent) -> void:
	if not interactable:
		return
	
	if Input.is_action_just_pressed("interact"):
		player.dir = Vector2.ZERO
		var dialogue = load("res://modules/levels/cafeteria/questgiver/juni_hungry.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
		get_viewport().set_input_as_handled()

	
func _on_interaction_circle_body_entered(body: Node2D) -> void:
	interactable = true
	$Display/Sprite2D.reparent($Display/Glint)
	
func _on_interaction_circle_body_exited(body: Node2D) -> void:
	interactable = false
	$Display/Glint/Sprite2D.reparent($Display)

	
func _test_if_ramen() -> bool:
	var inv : Inventory = GameManager.inventory_node.inventory
	if InventoryHelper.is_itemtype_in_inventory(inv, item_type):
		return true
	else:
		return false
		
func take_ramen():
	var inv : Inventory = GameManager.inventory_node.inventory
	if InventoryHelper.is_itemtype_in_inventory(inv, item_type):
		inv.consume_items({item_type: 1})
		quest_done = true
		InventoryHelper.add_itemtype_to_inventory(inv, return_item, 1)
		return true
	else:
		return false
		
func move_book():
	if table_book:
		table_book.position = Vector2(15, -4)
