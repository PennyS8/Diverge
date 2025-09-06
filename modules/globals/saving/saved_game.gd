class_name SavedGame
extends Resource

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
