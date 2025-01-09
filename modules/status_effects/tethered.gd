extends StatusEffectClass

const THREAD_LENGTH = 64
@onready var thread_line2d = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var p0 := Vector2.ZERO
	var p1 := Vector2.ZERO
	
	# Set the thread_line2d points to connect the tethered entity with the point other end of the thread
	# if player is holding the thread
	if get_tree().get_nodes_in_group("status_tethered").size() == 1:
		var player_pos = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0, -8)
		p0 = to_local(player_pos)
		p1 = Vector2.ZERO
	# if player has threaded 2 entities to eachother
	elif get_tree().get_nodes_in_group("status_tethered").size() == 2: # TODO: change to "elif"
		var tethered_entity_1 = get_tree().get_nodes_in_group("status_tethered")[0].global_position
		var tethered_entity_2 = get_tree().get_nodes_in_group("status_tethered")[1].global_position
		p0 = to_local(tethered_entity_1)
		p1 = to_local(tethered_entity_2)
	
	thread_line2d.points[0] = p0
	thread_line2d.points[1] = p1
	
	# Call pull() of the tethered entity's script if the thread is streched to its limit
	if p0.distance_to(p1) > THREAD_LENGTH:
		get_parent().get_parent().pull() # pull() func of the tethered entity's script
