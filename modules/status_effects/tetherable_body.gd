extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
var sliding_to_target := false

var leash_owner : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func select():
	if is_in_group("status_tethered"):
		return
	add_to_group("selected")
	#modulate = Color(1, 1, 0, 0.5)

func deselect():
	remove_from_group("selected")
	#modulate = Color(1, 1, 1, 1)

# Adds itself to the status_tethered global group
func add_tethered_status():
	#print("Adding "+self.name+" to group status_tethered")
	deselect()
	add_to_group("status_tethered")

# Removes itself from the status_tethered global group
func remove_tethered_status():
	#print("Removing "+self.name+" from group status_tethered")
	remove_from_group("status_tethered")

func _physics_process(_delta):
	# this is sooo ugly -- this is the case where player IS pulling towards themselves
	if !leash_owner:	
		leash_owner = player
		
	# else, deadeye has given us a leash owner (another tetherablebody)
	if leash_owner:
		if leash_owner == self:
			sliding_to_target = false
			return
		
		var dist = global_position.distance_to(leash_owner.global_position)
		
		if sliding_to_target and dist > 16:
			global_position = global_position.move_toward(leash_owner.global_position, 100*_delta)
		elif sliding_to_target and dist <= 16:
			# If we get to our target
			sliding_to_target = false
			
			# If it's another shade:
			#   check if shade is child of node in group cocoon
			#     if it is, increment cocoon, free self and yarn instance
			#     if it is not, create cocoon, delete self, hide leash owner's displays

				
			if leash_owner.is_in_group("enemy"):
				# If cocoon doesn't exist, make one as the parent of our Main Shade
				var cocoon = load("res://modules/entities/enemies/shades/shade_bundle/shade_stack.tscn")
				cocoon = cocoon.instantiate()
				leash_owner.add_sibling(cocoon)
				var trigger_health = get_node("HealthComponent").health
				var main_health = leash_owner.get_node("HealthComponent").health
				cocoon.shade_healths_stored.append(trigger_health)
				cocoon.shade_healths_stored.append(main_health)
				
				cocoon.global_position = leash_owner.global_position
				leash_owner.reparent(cocoon)
				
				leash_owner.get_node("Display").hide()
				# Lobotomize Main Shade
				leash_owner.get_node("ShadeFSM").disabled = true
				
				# Update the "leash_owners" of all of the other tetherables after reparenting
				var breath_manager = get_tree().get_first_node_in_group("deep_breath")
				breath_manager.update_tethers_to_cocoon(cocoon)
				
				# Remove the enemy that just reached the newly created cocoon
				self.queue_free()
			elif leash_owner.is_in_group("cocoon"):
				# if our cocoon already exists, add self to the stack
				leash_owner.shade_healths_stored.append(get_node("HealthComponent").health)
				self.queue_free()

# Retracts the length of the yarn, pulling the tethered body to the player
# TODO: replace tween position with a force on body in dir
func fling():
	if is_in_group("lever"):
		return
	
	sliding_to_target = true

# When a tethered node moves further from the other tethered node than the max\
# length of the yarn apply a force/movement to the other tethered node
func pull():
	if is_in_group("anchor"):
		#remove_tethered_status()
		return
	
	# Find the other tethered body that we are being pulled toward
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	var selected_body = tethered_nodes[0]
	if selected_body.name == name:
		if tethered_nodes.size() != 2:
			return
		selected_body = tethered_nodes[1]
	
	var end_point
	if selected_body.is_in_group("anchor"):
		end_point = global_position.lerp(selected_body.global_position, 0.8)
	else:
		var mid_point = global_position.lerp(selected_body.global_position, 0.5)
		end_point = global_position.lerp(mid_point, 0.75)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", end_point, 0.25)
