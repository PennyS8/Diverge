extends Panel

@onready var lab_inventory = %Equipment.inventory

func add_inventory_item(item_name: String):
	# Path to all of the chemistry lab material resources
	var resource_path = "res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/"
	var resource = load(resource_path + item_name + ".tres")
	var item_stack = ItemStack.new(resource, 1)
	
	if lab_inventory.try_add_item(item_stack):
		print("Item successfully added")
	else:
		print("Failed to add item to slot")

func combine_items():
	var converter = load("res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/substance_converter.tres")
	var converted_substance = converter.apply([lab_inventory])
	
	for sub in converted_substance:
		if lab_inventory.try_add_item(sub):
			print("Item successfully added")
		else:
			print("Failed to add item to slot")

func testing_print():
	print("Resource Name: ", lab_inventory.get_item_at_positionv(Vector2(0,0)).item_type.name)
