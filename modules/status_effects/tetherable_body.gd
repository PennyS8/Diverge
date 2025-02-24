extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("player")
var sliding_to_target := false
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
	if player:
		var dist = global_position.distance_to(player.global_position)
	
		if sliding_to_target and dist > 16:
			global_position = global_position.move_toward(player.global_position, 100*_delta)
		elif dist <= 16:
			sliding_to_target = false

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
