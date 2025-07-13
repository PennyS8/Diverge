extends Node2D

@onready var yarn_segment = preload("res://modules/entities/player/yarn/yarn_segment.tscn")

@onready var start_segment = $StartSegment
@onready var end_segment = $EndSegment
@onready var line2d_node = $Line2D

@export var static_end_segment : bool = false
@export var interval_scale_fator : float = 0.01
@export var base_interval : float = 10.0
@export var bias : float = 0.99
@export var softness : float = 0.003

var yarn_segments = []

func _ready() -> void:
	spawn_yarn()

func spawn_yarn():
	var start_pos = start_segment.get_node("PinJoint2D").global_position
	var end_pos = end_segment.get_node("PinJoint2D").global_position
	var dist = start_pos.distance_to(end_pos)
	
	var interval = base_interval + (dist * interval_scale_fator)
	var dir = (end_pos - start_pos).normalized()
	var num_segments = ceil(dist/interval)
	var rotation = dir.angle() - PI/2
	
	start_segment.segment_index = 0;
	var curr_pos = start_pos
	var curr_segment = start_segment
	yarn_segments = [start_segment]
	for index in range(num_segments):
		curr_segment = yarn_segments[index]
		
		curr_pos += dir * interval
		curr_segment = add_yarn_segment(curr_segment, index+1, rotation, curr_pos)
		yarn_segments.append(curr_segment)
		
		var joint_pos = curr_segment.get_node("PinJoint2D").global_position
		
		if joint_pos.distance_to(end_pos) < interval:
			break;
	
	connect_yarn_parts(end_segment, curr_segment)
	end_segment.rotation = rotation
	yarn_segments.append(end_segment)
	
	if static_end_segment:
		end_segment.freeze = true
	end_segment.segment_index = num_segments

func connect_yarn_parts(segment_a:Node2D, segment_b:Node2D):
	segment_a.get_node("PinJoint2D").node_a = segment_a.get_path()
	segment_a.get_node("PinJoint2D").node_b = segment_b.get_path()

func add_yarn_segment(prev_segment:Node2D, id:int, rotation:float, pos:Vector2):
	prev_segment.get_node("PinJoint2D")
	var segment = yarn_segment.instantiate()
	segment.global_position = pos
	segment.rotation = rotation
	segment.yarn = self
	segment.segment_index = id
	
	add_child(segment)
	prev_segment.get_node("PinJoint2D").node_a = prev_segment.get_path()
	prev_segment.get_node("PinJoint2D").node_b = segment.get_path()
	prev_segment.get_node("PinJoint2D").bias = bias
	prev_segment.get_node("PinJoint2D").softness = softness
	
	return segment

func _process(delta: float) -> void:
	update_line2d()

func update_line2d():
	var yarn_segment_points = []
	yarn_segment_points.append(start_segment.get_node("PinJoint2D").position)
	
	for segment in yarn_segments:
		yarn_segment_points.append(segment.position)
	yarn_segment_points.append(end_segment.get_node("PinJoint2D").position)
	line2d_node.points = yarn_segment_points
