extends Panel

@onready var lab_inventory = %Equip.inventory
@onready var player = get_tree().get_first_node_in_group("player")
var resource_path = "res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/"

var converter_name : String
var mixing_counter : int = 0

# Dictionary of all quest substance combinations which is used for item conversions.
# NOTE: This does not cover all of the substances as we spawn enemies if one is not found.
var recipes = {
	"purple" : load(resource_path + "purple_converter.tres"),
	"light_purple" : load(resource_path + "light_purple_converter.tres"),
	"brown" : load(resource_path + "brown_converter.tres"),
	"olive" : load(resource_path + "olive_converter.tres")
}

var mixing_substances = {
	"Orange Substance" : 0,
	"Yellow Substance" : 0,
	"Green Substance" : 0,
	"Blue Substance" : 0,
	"Purple Substance" : 0,
	"Light Purple Substance" : 0,
	"Brown Substance" : 0,
	"Olive Substance" : 0
}

@export var enemy_locations : Array[Vector2]


signal check_hook
func _on_equip_item_stack_added(_item_stack: ItemStack) -> void:
	check_hook.emit()

#region Chemistry Lab
func add_inventory_item(item_name: String, quantity : int = 1):
	# Path to all of the chemistry lab material resources
	var resource = load(resource_path + item_name + ".tres")
	var item_stack = ItemStack.new(resource, quantity)
	
	if lab_inventory.try_add_item(item_stack):
		print("Item successfully added")
	else:
		print("Failed to add item to slot")

func combine_items(station : String) -> bool:
	find_color_recipe(station)
	# If a recipe converter isn't found, we return false
	if converter_name == "":
		return false
	
	var converter = recipes.get(converter_name)
	var converted_substance = converter.apply([lab_inventory])
	
	for substance in converted_substance:
		print("Converted Substance: ", substance.item_type.name)
		if lab_inventory.try_add_item(substance):
			print("Item successfully added")
		else:
			print("Failed to add item to slot")
		
	return true

func failed_lab():
	# Player must start over so we reset all stations
	for station in player.lab_stations.values():
		station = 0
	
	# Delete items to allow player to restart
	delete_items()
	
	# TODO: Change this to get the entities node, no time right now
	var node = get_parent().get_parent()
	
	var spawn_counter = 0
	while spawn_counter < 4:
		var enemy_scene = load("res://modules/entities/enemies/shades/complex_shade/complex_shade.tscn")
		var enemy_node = enemy_scene.instantiate()
		
		get_tree().current_scene.add_child(enemy_node)
		enemy_node.global_position = enemy_node.global_position + enemy_locations[spawn_counter]
		spawn_counter = spawn_counter + 1

func delete_items():
	lab_inventory.clear()

func find_color_recipe(station : String):
	for recipe in recipes.values():
		# The recipes only have 1 tag (the station) so we just check the first spot in the array
		if recipe.tags[0] == station:
			# If we find the needed recipe, leave the function
			var recipe_items : Array[Resource] = recipe.input_types
			
			if has_needed_items(recipe_items):
				converter_name = recipes.find_key(recipe)
				return
	
	converter_name = ""

## Helper function to check the player's inventory for items needed for a specific recipe
func has_needed_items(needed_items : Array[Resource]) -> bool:
	for needed in needed_items:
		var found = false
		
		for item in mixing_substances:
			if item == needed.name:
				found = true
		
		# If a required item is not found in either of the slots, return false
		if found == false:
			return false
	
	return true

## Helper function to check how many substances are in the inventory for the chem lab.
func has_substance() -> int:
	var substance : int = 0
	var inv = lab_inventory.count_all_items()
	for item in inv:
		# Checks whether the crafting flag is enabled. Must access it from class name
		# due to the slot flags enum being local.
		if is_crafting(item):
			substance += 1
	
	return substance

## Helper function for checking for item's crafting flag
func is_crafting(item) -> bool:
	if item.slot_flags & ItemType.SlotFlags.CRAFTING != 0:
		return true
	
	return false

## Helper function that returns true if specified material is found in inventory
func has_specific_substance(substance_name : String) -> bool:
	var inv = lab_inventory.count_all_items()
	for item in inv:
		if is_crafting(item):
			# Checks the mixing counter in order to make sure that we aren't counting the same
			# substance twice.
			if item.name == substance_name && inv[item] > mixing_substances[item.name]:
				return true
	
	return false

func mark_mixing_substance(substance_name : String):
	for substance in mixing_substances:
		if substance == substance_name:
			mixing_substances[substance_name] += 1
			mixing_counter += 1
			
			return

func station_complete(station_name : String):
	if station_name in player.lab_stations:
		player.lab_stations[station_name] = 1

func station_incomplete(station_name : String):
	if station_name in player.lab_stations:
		player.lab_stations[station_name] = 0

func pick_up_book():
	var player_inventory = GameManager.inventory_node.inventory 
	var book = load("res://modules/objects/library_book_lab.tres")
	InventoryHelper.add_itemtype_to_inventory(player_inventory, book, 1)
	#player_inventory.save_state("player_inventory")
#endregion
