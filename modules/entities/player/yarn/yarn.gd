extends Node2D

@onready var yarn_segment = preload("res://modules/entities/player/yarn/yarn_segment.tscn")

@onready var yarn_start = $YarnStart
@onready var yarn_end = $YarnEnd
@onready var line2d_node = $Line2D

var static_yarn_end : bool = false
var interval_scale_fator : float = 0.03
var yarn_segment_points = []
var yarn_segments = []

func _ready() -> void:
	spawn_yarn()

func spawn_yarn():
	var start_pos = yarn_start.get_node("PinJoint2D").global_position
	var end_pos = yarn_end.get_node("PinJoint2D").global_position
	var dist = start_pos.distance_to(end_pos)
	
	var base_interval : float = 10.0
	var interval = base_interval + (dist * interval_scale_fator)
	var dir = (end_pos - start_pos).normalized()
	var num_segments = ceil(dist/interval)
	var rotation = dir.angle() - PI/2
	
	yarn_start.segment_index = 0;
	var curr_pos = start_pos
	var curr_segment = yarn_start
	yarn_segments = [yarn_start]
	for index in range(num_segments):
		curr_segment = yarn_segments[index]
		
		curr_pos += dir * interval
		curr_segment = add_yarn_segment(curr_segment, index+1, rotation, curr_pos)
		yarn_segments.append(curr_segment)
		
		var joint_pos = curr_segment.get_node("PinJoint2D").global_position
		
		if joint_pos.distance_to(end_pos) < interval:
			break;
	
	connect_yarn_parts(yarn_end, curr_segment)
	yarn_end.rotation = rotation
	yarn_segments.append(yarn_end)
	
	if static_yarn_end:
		yarn_end.freeze = true
	yarn_end.segment_index = num_segments

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
	prev_segment.get_node("PinJoint2D").bias = 0.99
	prev_segment.get_node("PinJoint2D").softness = 0.003
	
	return segment

func update_line2d():
	yarn_segment_points = []
	yarn_segment_points.append(yarn_start.get_node("PinJoint2D").global_position)
	
	for segment in yarn_segments:
		yarn_segment_points.append(segment.global_position)
	yarn_segment_points.append(yarn_end.get_node("PinJoint2D").global_position)
	line2d_node = yarn_segment_points

func _process(delta: float) -> void:
	update_line2d()
