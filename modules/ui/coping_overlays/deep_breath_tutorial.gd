extends ColorRect

var icons : Array[Node2D]
var tutorial_in_progress := false
var cope_in_progress := false

var shades : Array[Node]

func start_deep_breath_tutorial():
	tutorial_in_progress = true
	get_tree().paused = true
	
	hud_indicator_q()

func hud_indicator_q():
	var icon_path = "res://modules/ui/input_button_overlays/press_q.tscn"
	var icon : Node2D = load(icon_path).instantiate()
	
	get_parent().get_parent().get_node("ScreenFXExclusion").add_child(icon)
	icon.global_position = LevelManager.player.global_position + Vector2(0, -48)
	icons.append(icon)

func _unhandled_input(_event: InputEvent) -> void:
	if !tutorial_in_progress or cope_in_progress:
		return
	
	if Input.is_action_just_pressed("deep_breath"):
		cope()
		get_viewport().set_input_as_handled()

func cope():
	cope_in_progress = true
	
	for node in icons:
		node.queue_free()
	
	shades = get_tree().get_nodes_in_group("enemy")
	
	if !LevelManager.overlay:
		LevelManager.overlay = get_tree().get_first_node_in_group("deep_breath")
	
	LevelManager.overlay.tutorial_bodies = shades
	await LevelManager.deep_breath_overlay(true)
	
	exit_deep_breath_tutorial()
	Music.play_track(Music.Vibe.CONFIDENT)

func exit_deep_breath_tutorial():
	tutorial_in_progress = false
	cope_in_progress = false
	self.hide()
	get_tree().paused = false
	LevelManager.player.get_node("PlayerFSM").call_deferred("change_state", "CanDash")
	LevelManager.player.get_node("PlayerFSM").call_deferred("change_state", "CanAttack")
