class_name SavedGame
extends Resource

# Mirrors the Vibe enum in modules/globals/music_manager.gd. 
enum MusicVibe { CHILL, WTF, CONFIDENT }

#region Player information
@export var player_position : Vector2
@export var player_health : float
@export var player_max_health : float
@export var dialogue_tracker : Dictionary
#endregion

#region Level information
@export var saved_data : Array[SavedData] = []
@export var level_path : String
@export var current_level_name : String

## Stores the music whenever the track is switched - that way, on load game, the music continues with the right track.
## This is preferable right now to setting designated "Zones" for each track, since that would require adding data to each level.
## At the moment that solution is unrealistic, but perhaps that will change in the longterm.
## -Nate, 9/7/25
@export var last_playing_music : MusicVibe
#endregion

#region Respawn information
@export var respawn_last_level_path : String
@export var respawn_last_level_name : String
@export var respawn_last_entrance : String
#endregion

#region Chemistry Lab info
@export var lab_stations : Dictionary
#endregion

#region Classroom info
@export var stress_visible : bool
#endregion
