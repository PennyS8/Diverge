extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Adds a specified status by name
## including the global group & the status node
func add_status(status_name:String):
	get_parent().add_to_group("status_"+status_name)
	var status_node = load("res://modules/status_effects/"+status_name+".tscn")
	var status = status_node.instantiate()
	add_child(status)

## Removes a specified status by name
## including the global group & the status node
func remove_status(status_name:String):
	var status = get_node(status_name)
	get_parent().remove_from_group("status_"+status_name.to_lower())
	get_node(status_name).queue_free() # TODO: node is not being removed
