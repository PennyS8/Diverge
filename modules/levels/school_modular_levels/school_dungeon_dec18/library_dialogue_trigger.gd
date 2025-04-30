extends Area2D

@onready var spike_list = $"../JuniperSpikes".get_children()
@export var cope_item : ItemType
var player

func _ready() -> void:
	player = LevelManager.player
	if player.dialogue_tracker["library"] and $"../block exit" != null:
		$"../block exit".queue_free()

func _on_body_entered(body: Node2D) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.start(1)
	await timer.timeout
	player = LevelManager.player
	if(player.dialogue_tracker["library"] == false):
		DialogueManager.show_dialogue_balloon(load("res://modules/dialogue/demo_scenes.dialogue"), "library_entry", [self])
		$"../block exit".queue_free()
		player.dialogue_tracker["library"] = true

func add_item():
	var inv = GameManager.inventory_node.inventory
	InventoryHelper.add_itemtype_to_inventory(inv, cope_item, 1)
