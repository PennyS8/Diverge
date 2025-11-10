extends Node2D

@export var spawn_locations : Dictionary[Marker2D, CharacterBody2D]
@export var needed_mats : Dictionary[ItemType, bool]
@export var materials : Array[ItemType]

var substance_packed : PackedScene = preload("res://modules/levels/school_modular_levels/chem_lab_puzzle/chem_lab_inventory/inventory_items/substance.tscn")

func _ready() -> void:
	var randi = randi_range(3, 7)
	
	for i in randi:
		add_random_material()

## Adds a random material (or a random needed material if not all needed materials
## have spawned) to a random location.
func add_random_material() -> void:
	var random_point = spawn_locations.keys().pick_random()
	var random_mat
	
	if has_needed_mats():
		var randi = randi_range(0, materials.size()-1)
		random_mat = materials[randi]
	else:
		# If has_needed_mats() returns false, it marks the needed material for spawning.
		for mat in needed_mats:
			if needed_mats[mat] == false:
				random_mat = mat
				
				needed_mats[mat] = true
				
				break
	
	var substance = substance_packed.instantiate()
	random_point.add_child(substance)
	
	substance.set_substance_type(random_mat)
	
	substance.global_position = random_point.global_position
	
	spawn_locations[random_point] = substance
	

func remove_material(mat : ItemType) -> void:
	var spawn_location = spawn_locations.find_key(mat)
	
	# Sets the location the material was at back to null
	spawn_locations[spawn_location] = null

## Checks to see if all needed materials have been spawned in
func has_needed_mats() -> bool:
	for mat in needed_mats:
		# If a needed material wasn't set to true, we know all the required materials aren't spawned.
		if needed_mats[mat] == false:
			return false
	
	# If the for loop didn't return false, we know we have all the needed materials.
	return true

## Removes existing spawn_locations. NOTE: Does not delete the actual items.
func remove_existing_spawns() -> void:
	spawn_locations.clear()

## Adds saved spawns to spawn_locations.
func add_existing_spawns(existing_spawns : Dictionary[Marker2D, CharacterBody2D]) -> void:
	spawn_locations = existing_spawns

## NOTE: This function is used for consistent testing. ALSO not functional currently
#func _add_specific_material(mat : ItemType, loc : Marker2D) -> void:
	#spawn_locations[loc] = mat
