extends Node2D

#
# Class Status defines the functionalities of ALL status effects.
# The functions in this class are overwritten by each status effect node
# added to the status holder node of the node that is affected.
#
class_name StatusEffectsClass

@onready var thread_line2d : Line2D
var YARN_LENGTH = 128

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	thread_line2d = StatusEffectsManager.get_node_or_null("ThreadLine2D")
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	
	# Check if the yarn needs to be updated
	if tethered_nodes.size() != 2:
		if thread_line2d:
			thread_line2d.queue_free()
		return
	
	# Check if the yarn is over streched and breaks
	var node_1_pos : Vector2 = tethered_nodes[0].global_position
	var node_2_pos : Vector2 = tethered_nodes[1].global_position
	if node_1_pos.distance_to(node_2_pos) > YARN_LENGTH:
		for tethered_node in tethered_nodes:
			tethered_node.get_node("StatusHolder").remove_status("Tethered")
		if thread_line2d:
			thread_line2d.queue_free()
		return # Don't update thread_line2d if yarn has broken
	
	# Draw/update thread_line2d
	if not thread_line2d:
		create_thread_line2d()
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
	get_node(status_name).queue_free() # TODO: node is not being removed properly
	get_parent().remove_from_group("status_"+status_name.to_lower())

func create_thread_line2d():
	thread_line2d = Line2D.new()
	thread_line2d.set_name("ThreadLine2D")
	thread_line2d.default_color = Color(255, 255, 0, 0.5)
	thread_line2d.width = 2
	thread_line2d.z_index = 1
	StatusEffectsManager.add_child(thread_line2d)

func update_tethered_thread():
	if !thread_line2d:
		return
	
	thread_line2d.clear_points()
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	
	if tethered_nodes.size() == 2:
		var node_1_pos = tethered_nodes[0].global_position
		var node_2_pos = tethered_nodes[1].global_position
		var p1 = thread_line2d.to_local(node_1_pos)
		var p2 = thread_line2d.to_local(node_2_pos)
		thread_line2d.add_point(p1)
		thread_line2d.add_point(p2)
