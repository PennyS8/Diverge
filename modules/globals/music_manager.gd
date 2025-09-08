extends Node

@export var music_tracks : Dictionary[String, AudioStream]

enum Vibe { 
	## loop and chimes version.mp3: The track that plays when Juniper is having a "large" moment, 
	## or the stakes are very low. Plays on the title screen.
	CHILL,
	## texture.wav: The track that plays when something unnerving / unfamiliar 
	## is happening. Plays when Juni first encounters the shade in the closet.
	WTF,
	## Composure_v1.wav: The "main dungeon" theme. Was the first song composed 
	## by Willow for the game! Plays most of the time. Meant to exemplify the idea of
	## "figuring shit out".
	CONFIDENT 
}

## Stores the current vibe enum for save/load functionality
var current_vibe : Vibe

@onready var music_player = $Music

func play_track(vibe : Vibe):
	var next_track : AudioStream
	match vibe:
		Vibe.CHILL:
			next_track = music_tracks["chill"]
			current_vibe = Vibe.CHILL
		Vibe.WTF:
			next_track = music_tracks["wtf"]
			current_vibe = Vibe.WTF
		Vibe.CONFIDENT:
			next_track = music_tracks["confidence"]
			current_vibe = Vibe.CONFIDENT
	
	music_player.stream = next_track
	music_player.play()

func stop():
	music_player.stop()
