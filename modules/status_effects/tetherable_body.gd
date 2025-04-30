class_name TetherableBody
extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var boss = get_tree().get_first_node_in_group("boss")
var sliding_to_target := false

var leash_owner : Node2D
var yarn_instance # Mainly so that levers can remove their visual yarn instance

# Used for path comparison in coping mechanism
var boss_path = "res://modules/entities/enemies/shades/school_boss/school_boss.tscn"
var hand_path = "res://modules/entities/enemies/shades/school_boss/school_boss_hands.tscn"

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
	## this is sooo ugly -- this is the case where player IS pulling the body towards themselves
	#if self != player:
		#if !leash_owner:
			#leash_owner = player
	#else:
		#leash_owner = null
	#
	# else, deadeye has given us a leash owner (another tetherablebody)
	if leash_owner:
		# Prevents a cocoon of just hands or if hand is leash owner
		if leash_owner.scene_file_path == hand_path:
			return
		
		if leash_owner == self or self.is_in_group("boss"):
			sliding_to_target = false
			return
		
		var dist = global_position.distance_to(leash_owner.global_position)
		
		if sliding_to_target and dist > 16:
			global_position = global_position.move_toward(leash_owner.global_position, 100*_delta)
		elif sliding_to_target and dist <= 16:
			# If we get to our target
			sliding_to_target = false
			
			if (leash_owner.is_in_group("enemy") or leash_owner.is_in_group("boss")) and self.is_in_group("enemy"):
				# If cocoon doesn't exist, make one as the parent of our Main Shade
				var cocoon
				if leash_owner.is_in_group("boss"):
					cocoon = load("res://modules/entities/enemies/shades/school_boss_bundle/school_boss_stack.tscn")
				else: # If leash owner isn't boss, create a normal shade stack
					cocoon = load("res://modules/entities/enemies/shades/shade_bundle/shade_stack.tscn")
				
				cocoon = cocoon.instantiate()
				leash_owner.add_sibling(cocoon)
				cocoon.global_position = leash_owner.global_position
				
				var boss_spawned = get_tree().get_first_node_in_group("boss")
				var boss_cocoon_spawned = get_tree().get_first_node_in_group("boss_cocoon")
				
				#Checks to see if boss is in scene. If not we don't want to use boss functions
				if (boss_spawned != null) or (boss_cocoon_spawned != null):
					EnemyManager.add_hand(cocoon, cocoon.global_position)
					EnemyManager.remove_hand(self)
					EnemyManager.remove_hand(leash_owner)
					EnemyManager.remove_boss_spawned_enemy(self)
					EnemyManager.remove_boss_spawned_enemy(leash_owner)
				
				# Removes both leash owner and shade from encounter
				var encounter_entrances = get_tree().get_nodes_in_group("encounter_entrance")
				for entrance in encounter_entrances:
					if entrance.encounter_active:
						# Adds cocoon to prevent encounter from being disabled
						entrance.enemy_added(cocoon)
						
						entrance.enemy_defeated(self)
						entrance.enemy_defeated(leash_owner)
				
				# Store the healths of each shade to be re-instantiated later
				var trigger_health = get_node("%Health").health
				var main_health = leash_owner.get_node("%Health").health
				cocoon.shade_healths_stored.append(trigger_health)
				cocoon.shade_healths_stored.append(main_health)
				
				#Gets the type of enemy being cocooned
				var trigger_enemy_type = scene_file_path
				var main_enemy_type = leash_owner.scene_file_path
				cocoon.enemy_types_stored.append(trigger_enemy_type)
				cocoon.enemy_types_stored.append(main_enemy_type)
				
				# Lobotomize and Hide Main Shade
				leash_owner.get_node("%DisplayComponents").hide()
				leash_owner.get_node("ShadeFSM").disabled = true
				leash_owner.get_node("TetherableArea2D").monitoring = false
				leash_owner.get_node("TetherableArea2D").monitorable = false
				leash_owner.get_node("%AttackBox").monitorable = false
				leash_owner.get_node("%HurtBox").monitoring = false
				
				var main = leash_owner
				
				# Spawn cocoon
				leash_owner.reparent(cocoon)
				
				# Update the "leash_owners" of all of the other tetherables after reparenting
				var breath_manager = get_tree().get_first_node_in_group("deep_breath")
				breath_manager.update_tethers_to_cocoon(cocoon)
				
				# Remove the enemy that just reached the newly created cocoon
				main.queue_free()
				self.queue_free()
			elif (leash_owner.is_in_group("cocoon") or leash_owner.is_in_group("boss_cocoon")) and self.is_in_group("enemy"):
				# If our cocoon already exists, add self to the stack
				leash_owner.shade_healths_stored.append(get_node("%Health").health)
				leash_owner.enemy_types_stored.append(scene_file_path)
				
				var boss_cocoon_spawned = get_tree().get_first_node_in_group("boss_cocoon")
				var boss_spawned = get_tree().get_first_node_in_group("boss")
				
				#Checks to see if boss is in scene. If not we don't want to use boss functions
				if (boss_spawned != null) or (boss_cocoon_spawned != null):
					EnemyManager.remove_hand(self)
					EnemyManager.remove_boss_spawned_enemy(self)
								
				# Removes shade from encounter once it has been cocooned
				var encounter_entrances = get_tree().get_nodes_in_group("encounter_entrance")
				for entrance in encounter_entrances:
					if entrance.encounter_active:
						entrance.enemy_defeated(self)
				
				self.queue_free()

# Retracts the length of the yarn, pulling the tethered body to the player
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
