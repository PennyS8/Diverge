extends Node2D

var playerNoise: ColorRect  # Store the reference

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		playerNoise = player.get_node("%stressEffect")

func _on_area_2d_body_entered(body: Node2D) -> void:
	print('Collision detected with: ', body)
	if playerNoise:
		playerNoise.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	print('Collision ended with: ', body)
	if playerNoise:
		playerNoise.hide()
