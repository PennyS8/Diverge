extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	LevelManager.player.dir = Vector2.ZERO
	DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "not_goin_dat_way", [self])
	
