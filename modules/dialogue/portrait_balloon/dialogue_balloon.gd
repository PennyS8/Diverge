extends CanvasLayer

## The action to use for advancing the dialogue
const NEXT_ACTION = &"ui_accept"

## The action to use to skip typing the dialogue
const SKIP_ACTION = &"ui_cancel"


@export var talk_sound: AudioStream

@onready var balloon: Control = %Balloon
@onready var portrait_position: Marker2D = %PortraitPosition
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var notification_balloon: Control = %Notification
@onready var notification_label: RichTextLabel = %NotificationLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var portrait_container : PanelContainer = %PortraitContainer
var portrait: BasePortrait

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		mutation_cooldown.stop()

		notification_balloon.hide()

		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		var is_changing_character: bool = character_label.text != tr(dialogue_line.character)
		var has_character: bool = dialogue_line.character != ""

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character)

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.responses = dialogue_line.responses

		if has_character:
			# Show our balloon
			balloon.show()
			portrait_container.show()
			portrait_position.show()
		else:
			notification_balloon.show()
			notification_label.text = "[center]%s" % dialogue_line.text

		if is_changing_character:
			await hide_character()
			await show_character(dialogue_line.character)

		if has_character:
			if is_instance_valid(portrait):
				portrait.emote(dialogue_line.tags)
				
			will_hide_balloon = false
			dialogue_label.show()
			if not dialogue_line.text.is_empty():
				dialogue_label.type_out()
				await dialogue_label.finished_typing

			# Wait for input
			if dialogue_line.responses.size() > 0:
				balloon.focus_mode = Control.FOCUS_NONE
				responses_menu.show()
			elif dialogue_line.time != "":
				var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
				await get_tree().create_timer(time).timeout
				next(dialogue_line.next_id)
			else:
				is_waiting_for_input = true
				balloon.focus_mode = Control.FOCUS_ALL
				balloon.grab_focus()
		else:
			is_waiting_for_input = true
			notification_balloon.focus_mode = Control.FOCUS_ALL
			notification_balloon.grab_focus()

	get:
		return dialogue_line

var mutation_cooldown: Timer = Timer.new()


func _ready() -> void:
	balloon.hide()
	notification_balloon.hide()
	portrait_container.hide()
	DialogueManager.mutated.connect(_on_mutated)

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	if not is_node_ready():
		await ready
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Helpers


func hide_character() -> void:
	if is_instance_valid(portrait):
		#animation_player.play("hide_character")
		#await animation_player.animation_finished
		%PortraitBox.hide()
		portrait_position.remove_child(portrait)
		portrait.queue_free()


func show_character(character_name: String) -> void:
	if not character_name: return
	var soundpath = "res://modules/dialogue/character/%s/talk.wav" % character_name.to_lower()
	if FileAccess.file_exists(soundpath):
		talk_sound = load(soundpath)
	else:
		talk_sound = load("res://modules/dialogue/portrait_balloon/talk.wav")
		
	var portraitpath = "res://modules/dialogue/character/%s/portrait.tscn" % character_name.to_lower()
	if FileAccess.file_exists(portraitpath):
		var portrait_scene: PackedScene = load(portraitpath)
		
		%PortraitBox.show()
		
		portrait = portrait_scene.instantiate()
		portrait_position.add_child(portrait)
		#animation_player.play("show_character")
		#await animation_player.animation_finished


#endregion

#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()
		portrait_position.hide()
		notification_balloon.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(SKIP_ACTION)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(NEXT_ACTION) and (get_viewport().gui_get_focus_owner() == balloon or get_viewport().gui_get_focus_owner() == notification_balloon):
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


func _on_dialogue_label_spoke(letter: String, letter_index: int, _speed: float) -> void:
	if [" ", "."].has(letter): return
	if letter_index % 2 == 0: return

	audio_stream_player.stream = talk_sound
	audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player.play()


#endregion
