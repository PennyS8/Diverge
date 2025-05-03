extends Node2D

@export var inventory_path : NodePath
@export var command_items : Dictionary[String, ItemType]

func _ready():
	# Deletes 'temp' save folder if it exists
	SaveAndLoad.delete_room_saves()
	LevelManager.main_ready.emit()
	SaveAndLoad.main_ready.emit()
	GameManager.inventory_node = get_node(inventory_path)
	
	if OS.is_debug_build():
		LimboConsole.register_command(add_item, "givi", "Gives a user a requested item from a configured set of names in main.tscn.")
		LimboConsole.add_argument_autocomplete_source("givi", 1, func(): return command_items.keys())
		
		LimboConsole.register_command(add_all_items, "givall", "Gives a user all items in dictionary in main.tscn.")
		LimboConsole.register_command(clear_inv, "clrall", "Clears user's inventory.")

func add_item(item_name : String) -> bool:
	var inventory_node = GameManager.inventory_node
	if !inventory_node:
		LimboConsole.info("inventory node not in scene!")
		return false
	
	if !command_items.has(item_name):
		LimboConsole.info("item not present in item dictionary!")
		return false
	
	var item : ItemType = command_items[item_name]
	InventoryHelper.add_itemtype_to_inventory(inventory_node.inventory, item, 1)
	LimboConsole.info("gave inventory one count of " + item.name)
	return true

func add_all_items() -> bool:
	var inventory_node = GameManager.inventory_node
	if !inventory_node:
		LimboConsole.info("inventory node not in scene!")
		return false
	
	for item in command_items.values():
		InventoryHelper.add_itemtype_to_inventory(inventory_node.inventory, item, 1)
		LimboConsole.info("gave inventory one count of " + item.name)
	
	return true

func clear_inv() -> bool:
	var inventory_node = GameManager.inventory_node
	if !inventory_node:
		LimboConsole.info("inventory node not in scene!")
		return false
	
	var inventory : Inventory = inventory_node.inventory
	inventory.clear()
	LimboConsole.info("cleared current inventory.")

	DirAccess.remove_absolute("user://player_inventory")
	LimboConsole.info("deleted inventory file in user directory.")

	return true
	
func _on_equipment_panel_check_hook() -> void:
	if get_node_or_null("Player"):
		$Player.check_unlock_hook()
