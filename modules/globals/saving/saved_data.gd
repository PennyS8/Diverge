class_name SavedData
extends Resource

# Required to be assigned a value
@export var position:Vector2
@export var scene_path:String

# Not required to be assigned a value
@export var puzzle_completed:bool
@export var puzzle_key_id:int

# All of the exits to each room of a level (for dynamic transition_zones)
@export var room_transitions:Dictionary
