extends Node2D

@onready var plumbob = $ColorRect 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plumbob.color = Color(255, 255, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if check_status().is_empty():
		plumbob.color = Color(255, 255, 0, 0)
	else:
		plumbob.color = Color(255, 255, 0, 0.5)



func check_status():
	var status : Array = []
	for node in get_children():
	# NOTE: All child nodes of the StatusHolder are seen as status effects EXCEPT the plumbob
		if node is not ColorRect:
			status.append(node)
	
	return status
