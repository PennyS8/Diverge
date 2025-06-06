extends Node2D

var read1 : bool = false
var read2 : bool = false

@onready var marker1 = $Marker2D
@onready var marker2 = $Marker2D2

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if read1:
		return
	read1 = true
	
	_body.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/school_modular_levels/school_dungeon_act_one/admin.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "start", [self])

func got_key():
	if read2:
		return
	read2 = true
	
	LevelManager.player.dir = Vector2.ZERO
	var dialogue = load("res://modules/levels/school_modular_levels/school_dungeon_act_one/admin.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "got_it", [self])
