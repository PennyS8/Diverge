extends Node2D

var status_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var prev_count = status_count
	var status = check_status()
	status_count = status.size()
	#if prev_count != status_count:
		#update_plumbobs(status)
	


func update_plumbobs(status):
	# TODO: update plumbobs on status lost/gained, & custom status plumbob colors 
	# remove old plumbobs
	for node in get_children():
		if node is ColorRect:
			remove_child(node)
	# draw new plumbobs
	for i in status.size():
		var plumbob := ColorRect
		plumbob.size = Vector2(4, 4)
		plumbob.position = Vector2(0, -16)
		plumbob.rotation = -135 + (30*i)
		plumbob.color = Color(255*randf(), 255*randf(), 255*randf(), 0.5)
		add_child(plumbob) # TODO: ERROR
	


func check_status():
	var status : Array = []
	for node in get_children():
	# NOTE: All child nodes of the StatusHolder are seen as status effects EXCEPT the plumbob
		if node is not ColorRect:
			status.append(node)
	
	return status
