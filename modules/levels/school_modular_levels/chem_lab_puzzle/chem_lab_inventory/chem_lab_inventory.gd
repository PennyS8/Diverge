extends Panel

@onready var lab_inventory = %Equipment.inventory
var resource_path = "res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/"

var converter_name : String

# Dictionary of all quest substance combinations which is used for item conversions.
# NOTE: This does not cover all of the substances as we spawn enemies if one is not found.
var recipes = {
	"purple" : load(resource_path + "purple_converter.tres"),
	"brown" : load(resource_path + "brown_converter.tres"),
	"olive" : load(resource_path + "olive_converter.tres")
}

func add_inventory_item(item_name: String):
	# Path to all of the chemistry lab material resources
	var resource = load(resource_path + item_name + ".tres")
	var item_stack = ItemStack.new(resource, 1)
	
	if lab_inventory.try_add_item(item_stack):
		print("Item successfully added")
	else:
		print("Failed to add item to slot")

func combine_items() -> bool:
	find_color_recipe()
	# If a recipe converter isn't found, we return false
	if converter_name == "":
		return false
	
	var converter = recipes.get(converter_name)
	var converted_substance = converter.apply([lab_inventory])
	
	for substance in converted_substance:
		if lab_inventory.try_add_item(substance):
			print("Item successfully added")
		else:
			print("Failed to add item to slot")
		
	return true

func delete_items():
	pass

func find_color_recipe():
	for recipe in recipes.values():
		# If we find the needed recipe, leave the function
		var recipe_items : Array[Resource] = recipe.input_types
		
		if has_needed_items(recipe_items):
			converter_name = recipes.find_key(recipe)
			print("FOUND RECIPE")
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
