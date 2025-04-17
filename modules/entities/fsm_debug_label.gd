extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "ACTIVE STATES: \n"
	for item in $"../ShadeFSM".active_states.keys().slice(1):
		text += item + "\n"
