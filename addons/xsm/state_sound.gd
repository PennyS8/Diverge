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
@icon("res://addons/xsm/icons/state_sound.png")
extends StateAnimation
class_name StateSound

# StateSound is there for all your States that play a sound
#
# The usual way of using this class is to add a StateSound
# As a substate of a StateAnimation
#
# You have additionnal functions to inherit:
#  _on_sound_finished()
#
# There are additionnal functions to call in your StateAnimation:
#  play(sound: String, custom_speed: float = 1.0, from_end: bool = false) -> void:
#  play_backwards(sound: String) -> void:
#  play_blend(sound: String, custom_blend: float, custom_speed: float = 1.0,
#  play_sync(sound: String, custom_speed: float = 1.0,
#  pause() -> void:
#  queue(sound: String) -> void:
#  stop(reset: bool = true) -> void:
#  is_playing(sound: String) -> bool:



# EXPORTS
#
# Is exported in "_get_property_list():"
#
var sound_loop_mode := LOOP_NONE:
	set(value):
		sound_loop_mode = value
		notify_property_list_changed()
var nb_of_sound_loops := 2
var nb_play_per_anim := 1
var on_sounds_finished := FINISHED_CALLBACK_ONLY


enum {POS_NONE, POS_2D, POS_3D}

var sample : AudioStream :
	set(value):
		sample = value
		notify_property_list_changed()
		_create_stream()
var positional := POS_NONE :
	set(value):
		positional = value
		notify_property_list_changed()
		_create_stream()
var volume_db := 0.0 :
	set(value):
		volume_db = value
		_create_stream()
var pitch_scale := 1.0 :
	set(value):
		pitch_scale = value
		_create_stream()
var pitch_randomness := 0.0 :
	set(value):
		pitch_randomness = value
		# _create_stream()
var max_polyphony := 5 :
	set(value):
		max_polyphony = value
		_create_stream()
var bus := "From Parent" :
	set(value):
		bus = value
		_create_stream()
# for non positionnal sound
# get AudioStreamPlayer.MixTarget
var positional_mix_target := AudioStreamPlayer.MIX_TARGET_STEREO :
	set(value):
		positional_mix_target = value
		_create_stream()
# for positional sound (2D and 3D)
var positional_max_distance := 2000.0 :
	set(value):
		positional_max_distance = value
		_create_stream()
var positional_panning_strength := 1.0 :
	set(value):
		positional_panning_strength = value
		_create_stream()
# Careful, in AS2D and AS3D the area_mask is a mask selection tool
var positional_area_mask := 1 :
	set(value):
		positional_area_mask = value
		_create_stream()
# for 2D sound
# Careful, in AS2D the attenuation shows as a curve ?!
var positional_attenuation := 1.0 :
	set(value):
		positional_attenuation = value
		_create_stream()
# for 3D sound
var positional_attenuation_model := 0 :
	set(value):
		positional_attenuation_model = value
		_create_stream()
var positional_unit_size := 10 :
	set(value):
		positional_unit_size = value
		_create_stream()
var positional_max_db := 3 :
	set(value):
		positional_max_db = value
		_create_stream()
# 3 categories below
var positional_emission_angle_enabled := false :
	set(value):
		positional_emission_angle_enabled = value
		_create_stream()
var positional_emission_angle_degrees := 45.0 :
	set(value):
		positional_emission_angle_degrees = value
		_create_stream()
var positional_emission_angle_filter_attenuation_db := -12.0 :
	set(value):
		positional_emission_angle_filter_attenuation_db = value
		_create_stream()
var positional_attenuation_filter_cutoff_hz := 5000.0 :
	set(value):
		positional_attenuation_filter_cutoff_hz = value
		_create_stream()
var positional_attenuation_filter_db := -24.0 :
	set(value):
		positional_attenuation_filter_db = value
		_create_stream()
var positional_doppler_tracking := 0 :
	set(value):
		positional_doppler_tracking = value
		_create_stream()


# Non exported (private) variables
var stream_player = AudioStreamPlayer.new()
var current_sound_loop := 0
var sync_timer: SceneTreeTimer


#
# INIT
#

# We want to add some export variables in their categories
# And separate those of the root state

func _create_stream():
	var children = get_children()
	for c in get_children(true):
		if not children.has(c) and not c is Timer:
			c.queue_free()
	match positional:
		POS_NONE:
			stream_player = AudioStreamPlayer.new()
		POS_2D:
			stream_player = AudioStreamPlayer2D.new()
		POS_3D:
			stream_player = AudioStreamPlayer3D.new()
	stream_player.stream = sample
	stream_player.volume_db = volume_db
	stream_player.pitch_scale = pitch_scale
	# stream_player.pitch_randomness = pitch_randomness
	stream_player.max_polyphony = max_polyphony
	stream_player.bus = bus
	if positional == POS_NONE:
		stream_player.mix_target = positional_mix_target
	else:
		stream_player.max_distance = positional_max_distance
		stream_player.panning_strength = positional_panning_strength
		stream_player.area_mask = positional_area_mask
		if positional == POS_2D:
			stream_player.attenuation = positional_attenuation
		else:
			stream_player.attenuation_model = positional_attenuation_model
			stream_player.unit_size = positional_unit_size
			stream_player.max_db = positional_max_db
			stream_player.emission_angle_enabled = positional_emission_angle_enabled
			stream_player.emission_angle_degrees = positional_emission_angle_degrees
			stream_player.emission_angle_filter_attenuation_db = positional_emission_angle_filter_attenuation_db
			stream_player.attenuation_filter_cutoff_hz = positional_attenuation_filter_cutoff_hz
			stream_player.attenuation_filter_db = positional_attenuation_filter_db
			stream_player.doppler_tracking = positional_doppler_tracking

	add_child(stream_player, false, INTERNAL_MODE_BACK)
	stream_player.owner = null


func _get_property_list():
	var properties = []

	properties.append({
		name = "StateSound",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})

	properties.append({
		name = "sample",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "AudioStream"
	})
	if sample == null:
		return properties

	var can_sync = ""
	if anim_on_enter != "NONE" and anim_on_enter != "":
		can_sync = ", Sync with Anim"
	properties.append({
		name = "sound_loop_mode",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "None, Loop N times, Loop Forever%s" % can_sync
	})
	if sound_loop_mode == LOOP_SYNC:
		properties.append({
			name = "nb_play_per_anim",
			type = TYPE_INT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "1, 10, or_greater"
		})
	if sound_loop_mode == LOOP_N_TIMES:
		properties.append({
			name = "nb_of_sound_loops",
			type = TYPE_INT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "2, 10, or_greater"
		})
	if sound_loop_mode == LOOP_NONE or sound_loop_mode == LOOP_N_TIMES:
		properties.append({
			name = "on_sounds_finished",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "Callback only, Goto Next, Parent's Choice"
		})

	properties.append({
		name = "volume_db",
		type = TYPE_FLOAT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "-80, 24, 1.0, or_less, or_greater"
	})
	properties.append({
		name = "pitch_scale",
		type = TYPE_FLOAT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "-10, 10, 0.1, or_less, or_greater"
	})
	properties.append({
		name = "pitch_randomness",
		type = TYPE_FLOAT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0, 1, 0.1, or_greater"
	})

	properties.append({
		name = "max_polyphony",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "1, 8, 1, or_greater"
	})

	var buses = ""
	buses += "From Parent, "
	for i in AudioServer.bus_count:
		buses += AudioServer.get_bus_name(i) + ","
	properties.append({
		name = "bus",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = buses,
	})

	properties.append({
		name = "positional",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = "NONE, 2D, 3D"
	})
	# POSITIONAL GROUP
	properties.append({
		name = "positional_variables",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
		hint_string = "positional_"
	})
	if positional == POS_NONE:
		properties.append({
			name = "positional_mix_target",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = "MIX_TARGET_CENTER, MIX_TARGET_STEREO, MIX_TARGET_SURROUND"
		})
	else:
		properties.append({
			name = "positional_max_distance",
			type = TYPE_INT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0, 10000, or_greater"
		})
		properties.append({
			name = "positional_panning_strength",
			type = TYPE_FLOAT,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0.0, 3.0, 0.1, or_greater"
		})

		if positional == POS_2D:
			properties.append({
				name = "positional_attenuation",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_EXP_EASING,
				hint_string = "attenuation, positive_only"
			})		
		else:        
			# if POS_3D
			properties.append({
				name = "positional_attenuation_model",
				type = TYPE_INT,
				hint = PROPERTY_HINT_ENUM,
				hint_string = "Inverse, Inverse Square, Logarithmic, Disabled"
			})
			properties.append({
				name = "positional_unit_size",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "0.1, 100.0, 0.01, or_greater"
			})
			properties.append({
				name = "positional_max_db",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "-24.0, 6.0, 0.01"
			})
			properties.append({
				name = "emission_angle",
				type = TYPE_NIL,
				usage = PROPERTY_USAGE_SUBGROUP,
				hint_string = "positional_emission_angle_"
			})
			properties.append({
				name = "positional_emission_angle_enabled",
				type = TYPE_BOOL,
			})
			properties.append({
				name = "positional_emission_angle_degrees",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "0.1, 90.0, 0.01"
			})
			properties.append({
				name = "positional_emission_angle_filter_attenuation_db",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "-80, 0, 0.1"
			})

			properties.append({
				name = "attenuation_filter",
				type = TYPE_NIL,
				usage = PROPERTY_USAGE_SUBGROUP,
				hint_string = "positional_attenuation_filter_"
			})
			properties.append({
				name = "positional_attenuation_filter_cutoff_hz",
				type = TYPE_INT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "1, 20500"
			})
			properties.append({
				name = "positional_attenuation_filter_db",
				type = TYPE_FLOAT,
				hint = PROPERTY_HINT_RANGE,
				hint_string = "-80, 0, 0.1"
			})

			properties.append({
				name = "doppler",
				type = TYPE_NIL,
				usage = PROPERTY_USAGE_SUBGROUP,
				hint_string = "positional_doppler_"
			})
			properties.append({
				name = "positional_doppler_tracking",
				type = TYPE_INT,
				hint = PROPERTY_HINT_ENUM,
				hint_string = "Disabled, Idle, Physics"
			})

		properties.append({
			name = "positional_area_mask",
			type = TYPE_INT,
			hint = PROPERTY_HINT_LAYERS_2D_PHYSICS,
		})

	return properties


func _property_can_revert(property):
	if property == "sample":
		return true
	if property == "positional":
		return true
	if property == "volume_db":
		return true
	if property == "pitch_scale":
		return true
	if property == "pitch_randomness":
		return true
	if property == "max_polyphony":
		return true
	if property == "bus":
		return true
	if property == "on_sounds_finished":
		return true
	if property == "positional_mix_target":
		return true
	if property == "positional_mix_target":
		return true
	if property == "positional_max_distance":
		return true
	if property == "positional_panning_strength":
		return true
	if property == "positional_area_mask":
		return true
	if property == "positional_attenuation":
		return true
	if property == "positional_attenuation_model":
		return true
	if property == "positional_unit_size":
		return true
	if property == "positional_max_db":
		return true
	if property == "positional_emission_angle_enabled":
		return true
	if property == "positional_emission_angle_degrees":
		return true
	if property == "positional_emission_angle_filter_attenuation_db":
		return true
	if property == "positional_attenuation_filter_cutoff_hz":
		return true
	if property == "positional_attenuation_filter_db":
		return true
	if property == "positional_doppler_tracking":
		return true
	return false


func _property_get_revert(property):
	if property == "sample":
		return null
	if property == "positional":
		return POS_NONE
	if property == "volume_db":
		return 0.0
	if property == "pitch_scale":
		return 1.0
	if property == "pitch_randomness":
		return 0.0
	if property == "max_polyphony":
		return 5
	if property == "bus":
		return "From Parent"
	if property == "on_sounds_finished":
		return FINISHED_CALLBACK_ONLY
	if property == "positional_doppler_tracking":
		return 0
	if property == "positional_attenuation_filter_db":
		return -24.0
	if property == "positional_attenuation_filter_cutoff_hz":
		return 5000.0
	if property == "positional_emission_angle_filter_attenuation_db":
		return -12.0
	if property == "positional_emission_angle_degrees":
		return 45.0
	if property == "positional_emission_angle_enabled":
		return false
	if property == "positional_max_db":
		return 3
	if property == "positional_unit_size":
		return 10
	if property == "positional_attenuation_model":
		return 0
	if property == "positional_attenuation":
		return 1.0
	if property == "positional_area_mask":
		return 1
	if property == "positional_panning_strength":
		return 1.0
	if property == "positional_max_distance":
		return 2000.0
	if property == "positional_mix_target":
		return AudioStreamPlayer.MIX_TARGET_STEREO


#
# FUNCTIONS TO INHERIT
#
func _on_sound_finished() -> void:
	pass

func _on_sounds_finished() -> void:
	pass



#
# FUNCTIONS TO CALL IN INHERITED STATES
#
func play_sound():
	if not sample:
		return
		
	stream_player.pitch_scale = 1.0 + pitch_randomness * ( randf() * 2 - 1 )
	stream_player.play()



#
# PRIVATE FUNCTIONS
#

func play(anim: String, custom_speed: float = 1.0, from_end: bool = false) -> void:
	super(anim, custom_speed, from_end)

	if sound_loop_mode == LOOP_SYNC:
		current_sound_loop += 1
		play_sound()

		var anim_player = get_node_or_null(animation_player)
		var anim_length = anim_player.get_animation(anim).get_length()
		var divided_length = anim_length / nb_play_per_anim
		sync_timer = get_tree().create_timer(divided_length, false)
		sync_timer.timeout.connect(_on_sync_timer_timeout)


func enter(args = null) -> void:
	super(args)

	if sample and stream_player and sample.get_length() > 0:
		if sound_loop_mode != LOOP_SYNC:
			if not stream_player.finished.is_connected(_sound_finished):
				stream_player.finished.connect(_sound_finished)
			play_sound()


func exit(args = null) -> void:
	current_sound_loop = 0
	if sync_timer and sync_timer.timeout.is_connected(_on_sync_timer_timeout):
		sync_timer.timeout.disconnect(_on_sync_timer_timeout)
		sync_timer = null
	if stream_player and stream_player.finished.is_connected(_sound_finished):
		stream_player.finished.disconnect(_sound_finished)
	super(args)


func _sound_finished():
	_on_sound_finished()

	if sound_loop_mode == LOOP_N_TIMES:
		current_sound_loop += 1
		if current_sound_loop < nb_of_sound_loops:
			play_sound()
		else:
			_on_sounds_finished()
	
	if sound_loop_mode == LOOP_FOREVER:
		play_sound()


func _on_sync_timer_timeout():
	_on_sound_finished()
	current_sound_loop += 1
	if current_sound_loop < nb_play_per_anim:
		play_sound()

		var anim_player = get_node_or_null(animation_player)
		var anim_length = anim_player.get_animation(anim_on_enter).get_length()
		var divided_length = anim_length / nb_play_per_anim
		sync_timer = get_tree().create_timer(divided_length, false)
		sync_timer.timeout.connect(_on_sync_timer_timeout)
