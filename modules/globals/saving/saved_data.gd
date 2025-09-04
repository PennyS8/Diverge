class_name SavedData
extends Resource

@export var position : Vector2
@export var scene_path : String
@export var puzzle_completed : bool
@export var puzzle_key_id : int
@export var parent_node_path : NodePath
@export var max_health : int

#region Encounter Area
@export var child_nodes : Array[PackedScene]
@export var enemy_spawn_points : Array[NodePath]
#endregion
