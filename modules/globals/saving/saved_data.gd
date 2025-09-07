class_name SavedData
extends Resource

@export var position : Vector2
@export var scene_path : String
@export var puzzle_completed : bool
@export var puzzle_key_id : int
@export var parent_node_path : NodePath
@export var max_health : int

#region Encounter Area
@export var encounter_running : bool
@export var child_nodes : Array[PackedScene]
@export var enemy_spawn_points : Array[NodePath]
@export var enemy_in_encounter : bool
@export var horizontal_blocker_visible : bool
@export var vertical_blocker_visible : bool
@export var blocker_scale : Vector2
@export var blocker_collision_scale : Vector2
#endregion
