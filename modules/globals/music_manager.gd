extends Node

@export var music_tracks : Dictionary[String, AudioStream]

enum Vibe { CHILL, WTF, CONFIDENT }

@onready var music_player = $Music

func play_track(vibe : Vibe):
	var next_track : AudioStream
	match vibe:
		Vibe.CHILL:
			next_track = music_tracks["chill"]
		Vibe.WTF:
			next_track = music_tracks["wtf"]
		Vibe.CONFIDENT:
			next_track = music_tracks["confidence"]
	
	music_player.stream = next_track
	stop()
	music_player.play()

func stop():
	music_player.stop()
