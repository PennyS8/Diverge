# MIT LICENSE Copyright 2020-2021 Etienne Blanc - ATN
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
@tool
@icon("res://addons/xsm/icons/state_animation.png")
extends State
class_name StateAnimation

# StateAnimation is there for all your States that play an animation on enter
#
# The usual way of using this class is to add a StateAnimation in your tree
# Then, you can chose an anim_on_enter and how much time it will play
# In on_anim_finished in the inspector, you can define what you want to do next
#
# You have additionnal functions to inherit:
#  _on_anim_finished(_name)
#     where _name is the name of the animation
#     You can differentiate between animations played (using play() below)
#
# There are additionnal functions to call in your StateAnimation:
#  play(anim: String, custom_speed: float = 1.0, from_end: bool = false) -> void:
#  play_backwards(anim: String) -> void:
#  play_blend(anim: String, custom_blend: float, custom_speed: float = 1.0,
#  play_sync(anim: String, custom_speed: float = 1.0,
#  pause() -> void:
#  queue(anim: String) -> void:
#  stop(reset: bool = true) -> void:
#  is_playing(anim: String) -> bool:



enum {LOOP_NONE, LOOP_N_TIMES, LOOP_FOREVER, LOOP_SYNC}
enum {FINISHED_CALLBACK_ONLY, FINISHED_GOTO_NEXT, FINISHED_ASK_PARENT}


# EXPORTS
#
# Is exported in "_get_property_list():"
var anim_on_enter := "":
	set(value):
		anim_on_enter = value
		notify_property_list_changed()
var loop_mode := LOOP_NONE :
	set(value):
		loop_mode = value
		notify_property_list_changed()
var nb_of_loops := 1
var on_finished := FINISHED_GOTO_NEXT

# Is exported in "_get_property_list():" for root only
var animation_player: NodePath = NodePath():
	set(value):
		if value:
			animation_player = value
			notify_property_list_changed()
			update_configuration_warnings()


var current_loop := 0


#
# INIT
#
func _ready() -> void:
	super()

	if Engine.is_editor_hint() and not renamed.is_connected(_on_StateAnimation_renamed):
		renamed.connect(_on_StateAnimation_renamed)

	if animation_player == null or animation_player.is_empty():
		animation_player = guess_animation_player()
	


func _get_configuration_warning() -> String:
	if animation_player == null or animation_player.is_empty():
		var warning := "Warning : Your StateAnimation does not have an AnimationPlayer set up.\n"
		warning += "Either set it in the inspector or have an AnimationPlayer be a sibling of your XSM's root"
		return warning
	return ""


# We want to add some export variables in their categories
# And separate those of the root state
func _get_property_list():
	var properties = []

	var ap_ok := true
	# Will guess the AnimationPlayer each time
	# the inspector loads for this Node
	if animation_player == null or animation_player.is_empty():
		animation_player = guess_animation_player()
	if animation_player == null or animation_player.is_empty():
		ap_ok = false

	# Adds a State category in the inspector
	properties.append({
		name = "StateAnimation",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})

	properties.append({
		name = "animation_player",
		type = TYPE_NODE_PATH
	})

	# Will guess the animation to play
	if ap_ok:
		var ap = get_node_or_null(animation_player)
		if ap and ap.has_animation(name) and anim_on_enter == "":
			anim_on_enter = name


		var anims_hint = "NONE"
		if ap:
			for anim in get_node_or_null(animation_player).get_animation_list():
				anims_hint = "%s,%s" % [anims_hint, anim]
		properties.append({
			name = "anim_on_enter",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = anims_hint
		})

		if anim_on_enter != "NONE" and anim_on_enter != "": #ENTER_NONE:
			properties.append({
				name = "loop_mode",
				type = TYPE_INT,
				hint =  PROPERTY_HINT_ENUM,
				hint_string = "None, N Times, Forever"
			})
			if loop_mode == LOOP_N_TIMES:
				properties.append({
					name = "nb_of_loops",
					type = TYPE_INT,
					hint =  PROPERTY_HINT_RANGE,
					hint_string = "1,10,or_greater"
				})
			if loop_mode != LOOP_FOREVER:
				properties.append({
					name = "on_finished",
					type = TYPE_INT,
					hint = PROPERTY_HINT_ENUM,
					hint_string = "Callback Only:0, Goto Next:1, Parent's Choice:2"
				})

	update_configuration_warnings()
	return properties


func _property_can_revert(property):
	if property == "animation_player":
		return true
	if property == "nb_of_loops":
		return true
	if property == "on_finished":
		return true
	return super(property)


func _property_get_revert(property):
	if property == "animation_player":
		return guess_animation_player()
	if property == "nb_of_loops":
		return 1
	if property == "on_finished":
		return FINISHED_GOTO_NEXT
	return super(property)


#
# FUNCTIONS TO INHERIT
#
func _on_anim_finished() -> void:
	pass

func _on_loop_finished() -> void:
	pass


#
# FUNCTIONS TO CALL IN INHERITED STATES
#
func play(anim: String, custom_speed: float = 1.0, from_end: bool = false) -> void:
	if disabled or status != ACTIVE:
		return
	var anim_player = get_node_or_null(animation_player)
	if anim_player and anim_player.has_animation(anim):
		if not anim_player.is_playing() or anim_player.current_animation != anim:
			anim_player.play(anim)


func play_backwards(anim: String) -> void:
	play(anim, -1.0, true)


func play_blend(anim: String, custom_blend: float, custom_speed: float = 1.0,
		from_end: bool = false) -> void:
	var anim_player = get_node_or_null(animation_player)
	if status == ACTIVE and anim_player != null and anim_player.has_animation(anim):
		if anim_player.current_animation != anim:
			anim_player.play(anim, custom_blend, custom_speed, from_end)


func play_sync(anim: String, custom_speed: float = 1.0,
		from_end: bool = false) -> void:
	var anim_player = get_node_or_null(animation_player)
	if status == ACTIVE and anim_player != null and anim_player.has_animation(anim):
		var curr_anim: String = anim_player.current_animation
		if curr_anim != anim and curr_anim != "":
			var curr_anim_pos: float = anim_player.current_animation_position
			var curr_anim_length: float = anim_player.current_animation_length
			var ratio: float = curr_anim_pos / curr_anim_length
			play(anim, custom_speed, from_end)
			anim_player.seek(ratio * anim_player.current_animation_length)
		else:
			play(anim, custom_speed, from_end)


func pause() -> void:
	stop(false)


func queue(anim: String) -> void:
	var anim_player = get_node_or_null(animation_player)
	if status == ACTIVE and anim_player != null and anim_player.has_animation(anim):
		anim_player.queue(anim)


func stop(reset: bool = true) -> void:
	var anim_player = get_node_or_null(animation_player)
	if status == ACTIVE and anim_player != null:
		anim_player.stop(reset)
		state_root.current_anim_priority = 0


func is_playing(anim: String) -> bool:
	var anim_player = get_node_or_null(animation_player)
	if anim_player != null:
		return anim_player.current_animation == anim
	return false


#
# PRIVATE FUNCTIONS
#
func guess_animation_player() -> NodePath:
	if not state_root:
		return NodePath()
	for c in state_root.get_parent().get_children():
		if c is AnimationPlayer:
			return get_path_to(c)
	return NodePath()


func exit(args = null) -> void:
	current_loop = 0
	var anim_player = get_node_or_null(animation_player)
	if anim_player and anim_player.animation_finished.is_connected(_on_AnimationPlayer_animation_finished):
		anim_player.animation_finished.disconnect(_on_AnimationPlayer_animation_finished)
	super(args)


func enter(args = null) -> void:
	super(args)
	var anim_player = get_node_or_null(animation_player)
	if anim_player and not anim_player.animation_finished.is_connected(_on_AnimationPlayer_animation_finished):
		anim_player.animation_finished.connect(_on_AnimationPlayer_animation_finished)
	if anim_on_enter != "" and anim_on_enter != "NONE":
		play(anim_on_enter)


func _on_AnimationPlayer_animation_finished(finished_animation):
	if finished_animation == anim_on_enter:
		_on_anim_finished()
		match loop_mode:
			LOOP_NONE:
				match on_finished:
					FINISHED_GOTO_NEXT:
						change_to_next()
					FINISHED_ASK_PARENT:
						get_parent().change_to_next_substate()
			LOOP_FOREVER:
				play(finished_animation)
			LOOP_N_TIMES:
				current_loop += 1
				if current_loop >= nb_of_loops:
					_on_loop_finished()
					match on_finished:
						FINISHED_GOTO_NEXT:
							change_to_next()
						FINISHED_ASK_PARENT:
							get_parent().change_to_next_substate()


func _on_StateAnimation_renamed():
	# Will guess the animation to play
	var ap = get_node_or_null(animation_player)
	if ap and ap.has_animation(name) and anim_on_enter == "":
		anim_on_enter = name
