extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_status()
	


func check_status():
	var status : Array = []
	for node in get_children():
	# NOTE: All child nodes of the StatusHolder are seen as status effects EXCEPT the plumbob
		if node is not ColorRect:
			status.append(node)
	
