extends StatusEffectClass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tethered()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Overrides the get_tethered() in 
func get_tethered():
	print("DEBUG: get_tethered() Overrided")
