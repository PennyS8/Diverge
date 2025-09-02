class_name SavedGame
extends Resource

# Player information
@export var player_position:Vector2
@export var player_health:float
@export var player_max_health:float

# Level information
@export var saved_data:Array[SavedData] = []
@export var level_path:String
@export var current_level_name:String

#Respawn information
@export var respawn_last_level_path:String
@export var respawn_last_level_name:String
@export var respawn_last_entrance:String
