extends StatusEffectsClass

@onready var player = get_tree().get_first_node_in_group("player")
@onready var self_object : PhysicsBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	select()

func _on_area_2d_mouse_exited() -> void:
	deselect()

func select():
	if get_parent().is_in_group("status_tethered"):
		return
	get_parent().add_to_group("selected")
	get_parent().modulate = Color(255, 255, 0, 0.5)

func deselect():
	get_parent().remove_from_group("selected")
	get_parent().modulate = Color(255, 255, 255, 1)

# Retracts the length of the thread, pulling the tethered body to the player
# TODO: replace tween position with a force on body in dir
func fling_tethered_node():
	var player_pos = player.global_position
	var end_point = self_object.global_position.lerp(player_pos, 0.6)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self_object, "global_position", end_point, 0.2)
	
	# TODO: Remove this 
	remove_status("tethered")

# When a tethered node moves further from the other tethered node than the max\
# length of the thread apply a force/movement to the other tethered node
func pull_tethered_node():
	if self_object.is_in_group("anchor"):
		remove_status("tethered")
		return
	
	# Find the other tethered body that we are being pulled toward
	var tethered_nodes = get_tree().get_nodes_in_group("status_tethered")
	var body = tethered_nodes[0]
	if body.name == self_object.name:
		if tethered_nodes.size() != 2:
			return
		body = tethered_nodes[1]
	
	var end_point
	if body.is_in_group("anchor"):
		end_point = self_object.global_position.lerp(body.global_position, 0.8)
	else:
		var mid_point = self_object.global_position.lerp(body.global_position, 0.5)
		end_point = body.global_position.lerp(mid_point, 0.8)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self_object, "global_position", end_point, 0.25)
