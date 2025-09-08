extends ColorRect 

var icons : Array[Node2D]
var tutorial_in_progress := false

func start_attack_tutorial():
	get_tree().paused = true
	self.show()

	var icon_path = "res://modules/ui/input_button_overlays/left_click.tscn"
	var icon : Node2D = load(icon_path).instantiate()
	
	get_parent().get_parent().get_node("ScreenFXExclusion").add_child(icon)
	icon.global_position = get_tree().get_first_node_in_group("enemy").global_position
	icons.append(icon)
	
	tutorial_in_progress = true

func _unhandled_input(_event: InputEvent) -> void:
	if !tutorial_in_progress:
		return
	
	if Input.is_action_just_pressed("attack_melee"):
		exit_attack_tutorial()

func exit_attack_tutorial():
	tutorial_in_progress = false
	
	for node in icons:
		node.queue_free()
	
	self.hide()
	get_tree().paused = false
	LevelManager.player.fsm.change_state("AttackMelee")
	
