extends Node2D

@export var ramen_item : PackedScene

@onready var slim = $LunchShady
@onready var shadely = $Shadely
@onready var shadehouse = $BrickShadehouse
@onready var melisshade = $Melisshade

@onready var camera_lock_pos = $CameraLock.global_position

var end_cutscene : bool = false
var shade_who_got
var cutscene_watched : bool = false

func dispense(point, wanderer_spawn):
	var ramen_instance : Node2D = ramen_item.instantiate()
	ramen_instance.spawns_wanderer = wanderer_spawn
	point.add_child(ramen_instance)
	ramen_instance.name = "RamenTray"

func _on_debug_area_body_entered(body: Node2D) -> void:
	if !cutscene_watched:
		_move_cutscene_camera(camera_lock_pos)
		cutscene_watched = true

		var dispense_points = $DispensePoints.get_children()
		for point in dispense_points:
			point.spawns_wanderer = true
		var disabled_id = randi_range(0,4)
		var disabled_area = dispense_points[disabled_id]
		disabled_area.spawns_wanderer = false
		
		var dialogue = load("res://modules/levels/cafeteria/cafeteria_puzzle_intro.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "start", [self])
	
func _on_dispense_point_area_entered(area : Node2D, num : int) -> void:
	var point = get_node("DispensePoints/DispensePoint" + str(num))
	call_deferred("dispense", point, point.spawns_wanderer)

func _move_cutscene_camera(pos):
	LevelManager.player.enter_cutscene(pos)
	
func _unlock_shades():
	var shades = [shadely, shadehouse, melisshade]
	for shade in shades:
		var fsm = shade.get_node("ShadeFSM")
		fsm.disabled = false
		fsm.change_state("SeekingRamen")
	
func shades_attack():
	var shades = [shadely, shadehouse, melisshade]
	for shade in shades:
		var fsm = shade.get_node("ShadeFSM")
		fsm.disabled = false
		shade.get_node("Hurtbox").set_collision_mask_value(3, true)
		shade.get_node("TetherableArea2D").set_collision_layer_value(9, true)
		shade.get_node("TetherableArea2D").monitoring = true
		shade.get_node("TetherableArea2D").monitorable = true
		shade.follow_target = LevelManager.player
		fsm.change_state("Seeking")

func player_got_ramen():
	if !end_cutscene:
		_move_cutscene_camera(LevelManager.player.global_position)
		var dialogue = load("res://modules/levels/cafeteria/cafeteria_puzzle_intro.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "got_ramen", [self])
		end_cutscene = true
	
func shade_got_ramen(shade):
	if !end_cutscene:
		#set name for dialogue's sake
		shade_who_got = shade.name
		_move_cutscene_camera(shade.global_position)
		var dialogue = load("res://modules/levels/cafeteria/cafeteria_puzzle_intro.dialogue")
		DialogueManager.show_dialogue_balloon(dialogue, "lost_ramen", [self])
		end_cutscene = true
