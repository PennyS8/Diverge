extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("player")
	%Health.text = str(player.health_component.health)
	%SmallKeys.text = str(KeyChain.num_smallkeys)
	%BigKeys.text = str(KeyChain.num_bigkeys)
