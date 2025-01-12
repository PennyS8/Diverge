extends Node2D

#
# Class Status defines the functionalities of ALL status effects.
# The functions in this class are overwritten by each status effect node
# added to the status holder node of the node that is affected.
#
class_name StatusEffectsClass


@onready var thread_line2d : Line2D
@onready var sem = $"/root/StatusEffectsManager" # SEM (Status Effects Manager)
var THREAD_LENGTH = 64

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	thread_line2d = sem.get_node("ThreadLine2D")
	if get_tree().get_node_count_in_group("status_tethered") <= 0:
		if thread_line2d:
			thread_line2d.queue_free()
	else:
		if not thread_line2d:
			thread_line2d = Line2D.new()
			thread_line2d.set_name("ThreadLine2D")
			thread_line2d.default_color = Color(255, 255, 0, 0.5)
			thread_line2d.width = 2
			$"/root".move_child(sem, -1)
			sem.add_child(thread_line2d)
		
		update_tethered_thread()

# Adds a specified status by name
# including the global group & the status node
func add_status(status_name:String):
	get_parent().add_to_group("status_"+status_name)
	var status_node = load("res://modules/status_effects/"+status_name+".tscn")
	var status = status_node.instantiate()
	add_child(status)

# Removes a specified status by name
# including the global group & the status node
func remove_status(status_name:String):
	get_node(status_name).queue_free() # TODO: node is not being removed, just corrupted
	get_parent().remove_from_group("status_"+status_name.to_lower())

func get_tethered():
	return null

func get_stunned():
	return null

func get_fucked_lol():
	return null

func num_tethered_entities() -> float:
	var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
	var num_tethered = 0 # Excluding the player
	for entity in tethered_entities:
		if entity.name != "Player":
			num_tethered += 1
	return num_tethered

# When a tethered entity moves further from the other tethered entity than the max\
# length of the thread apply a force/movement to the other tethered entity
func pull_tethered_entity():
	pass

# Retracts the length of the thread, pulling the tethered entity to the fling point
func fling_tethered_entity(fling_point : Vector2):
	pass

func update_tethered_thread():
	thread_line2d.clear_points()
	var tethered_entities = get_tree().get_nodes_in_group("status_tethered")
	
	if tethered_entities.size() == 2:
		var entity_1_pos = tethered_entities[0].global_position
		var entity_2_pos = tethered_entities[1].global_position
		var p1 = thread_line2d.to_local(entity_1_pos)
		var p2 = thread_line2d.to_local(entity_2_pos)
		thread_line2d.add_point(p1)
		thread_line2d.add_point(p2)
