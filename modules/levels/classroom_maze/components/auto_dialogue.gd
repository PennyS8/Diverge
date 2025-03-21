extends Area2D

var iteration = 0

@onready var playerNoise
var dialogue = load("res://modules/levels/classroom_maze/anxious_classroom.dialogue")
@onready var camera_location = %CameraLocation
@export var book : ItemType
func _on_body_entered(body: Node2D) -> void:
	if !playerNoise:
		playerNoise = LevelManager.player.get_node("stressEffect")
	body.dir = Vector2.ZERO
	match iteration:
		0:
			LevelManager.player.enter_cutscene(camera_location.global_position)
			DialogueManager.show_dialogue_balloon(dialogue, "start")
		1:
			if InventoryHelper.is_itemtype_in_inventory(GameManager.inventory_node.inventory, book):
				LevelManager.player.enter_cutscene(camera_location.global_position)
				playerNoise.hide()
				DialogueManager.show_dialogue_balloon(dialogue, "complete")
				self.queue_free()
	iteration = iteration + 1
