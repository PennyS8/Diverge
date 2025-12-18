extends ColorRect 

var icons : Array[Control]
var tutorial_in_progress := false

func start_attack_tutorial():
	get_tree().paused = true
	self.show()

	var icon_path = "res://modules/ui/input_button_overlays/left_click.tscn"
	var icon : Control = load(icon_path).instantiate()
	
	var enemy : Node2D = get_tree().get_first_node_in_group("enemy")
	var enemy_loc = enemy.get_global_transform_with_canvas()
	
	var fx_exclusion_layer : CanvasLayer = get_parent().get_parent().get_node("ScreenFXExclusion")
	
	
	if enemy:
		fx_exclusion_layer.add_child(icon)
		icon.global_position = enemy.global_position
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
	
