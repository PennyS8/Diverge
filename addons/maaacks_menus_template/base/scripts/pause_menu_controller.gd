class_name PauseMenuController
extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var pause_menu_packed : PackedScene
@export var focused_viewport : Viewport

func _unhandled_input(event : InputEvent) -> void:
	# This is a bit specific, but handles an edgecase regarding the "Inside the school (juni is panicking)"
	# Transition into the attack tutorial (which is a placeholder.)
	# Stops user from opening pause menu when that transition is occurring
	var attack_tutorial_overtext = LevelManager.current_level.get_node_or_null("CanvasLayer/TransOverlay")
	if attack_tutorial_overtext:
		if attack_tutorial_overtext.visible:
			return
	
	if LevelManager.transitioning || LevelManager.encounter_transition:
		return
	if event.is_action_pressed("ui_cancel"):
		if not focused_viewport:
			focused_viewport = get_viewport()
		var _initial_focus_control = focused_viewport.gui_get_focus_owner()
		var current_menu = pause_menu_packed.instantiate()
		#get_tree().current_scene.call_deferred("add_child", current_menu)
		get_parent().call_deferred("add_child", current_menu)

		await current_menu.tree_exited
		if is_inside_tree() and _initial_focus_control:
			_initial_focus_control.grab_focus()
