extends Panel

@onready var lab_inventory = %Equipment.inventory
var resource_path = "res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/"

var converter_name : String

var stations = {
	"materials": 0,
	"scale": 0,
	"mixer": 0,
	"burner": 0,
	"book": 0
}

# Dictionary of all quest substance combinations which is used for item conversions.
# NOTE: This does not cover all of the substances as we spawn enemies if one is not found.
var recipes = {
	"purple" : load(resource_path + "purple_converter.tres"),
	"light_purple" : load(resource_path + "light_purple_converter.tres"),
	"brown" : load(resource_path + "brown_converter.tres"),
	"olive" : load(resource_path + "olive_converter.tres")
}

@export var enemy_locations : Array[Vector2]

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
	for station in stations.values():
		station = 0
	
	# Delete items to allow player to restart
	delete_items()
	
	# TODO: Change this to get the entities node, no time right now
	var node = get_parent().get_parent()
	
	var spawn_counter = 0
	while spawn_counter < 4:
		var enemy_scene = load("res://modules/entities/enemies/shades/shade/melee_shade.tscn")
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

# Helper function to check the player's inventory for items needed for a specific recipe
func has_needed_items(needed_items : Array[Resource]) -> bool:
	for needed in needed_items:
		var found = false
		
		for item in lab_inventory.items:
			if item.item_type.name == needed.name:
				found = true
		
		# If a required item is not found in either of the slots, return false
		if found == false:
			return false
	
	return true

func station_complete(station_name : String):
	if station_name in stations:
		stations[station_name] = 1

func station_incomplete(station_name : String):
	if station_name in stations:
		stations[station_name] = 0

func pick_up_book():
	var player_inventory = GameManager.inventory_node.inventory 
	var book = load("res://modules/objects/library_book_lab.tres")
	InventoryHelper.add_itemtype_to_inventory(player_inventory, book, 1)
